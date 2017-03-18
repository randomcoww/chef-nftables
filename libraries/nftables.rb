module Nftables
  class NftablesRules
    include Chef::Mixin::Which
    include Chef::Mixin::ShellOut

    attr_reader :run_context, :release_path, :template_variables

    def initialize(run_context, release_path, template_variables)
      @run_context = run_context
      @release_path = release_path
      @template_variables = template_variables
    end

    def load_rules_from_release_path
      rules = {}

      ::Dir.chdir(release_path)
      ::Dir.entries(release_path).each do |f|
        next unless ::File.file?(f)

        if ::File.extname(f) == '.erb'
          f = resolve_template(f)
        end

        if !rules.has_key?(f) && ::File.extname(f) == '.rules'
          rules[f] = true
        end
      end

      service = nftables_service(rules.keys.sort)
      service.run_action(:create)
      service.run_action(:enable)
      service.run_action(:restart)
    end

    private

    def resolve_template(t)
      f = ::File.basename(t, '.erb')
      Chef::Resource::Template.new(f, run_context).tap do |r|
        r.source t
        r.path f
        r.local true
        r.variables template_variables
      end.run_action(:create_if_missing)
      f
    end

    def nftables_service(rules)
      Chef::Resource::SystemdUnit.new('nftables.service', run_context).tap do |r|
        r.enabled true
        r.content ({
          "Unit" => {
            "Description" => "Netfilter Tables",
            "Wants" => "network-pre.target",
            "Before" => "network-pre.target"
          },
          "Service" => {
            "WorkingDirectory" => release_path,
            "Type" => "oneshot",
            "ExecStartPre" => "-#{nft_path} flush ruleset",
            "ExecStart" => rules.map { |e| "#{nft_path} -f #{e}" },
            "RemainAfterExit" => "yes"
          },
          "Install" => {
            "WantedBy" => "multi-user.target"
          }
        })
      end
    end

    def nft_path
      @nft_path ||= which('nft')
    end
  end
end
