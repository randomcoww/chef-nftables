module NftablesMethods
  include Chef::Mixin::Which
  include Chef::Mixin::ShellOut

  def nft_load_rules_from_path(template_variables)
    template_variables['release_path'] = release_path
    rules = {}

    ::Dir.chdir(release_path)
    ::Dir.entries(release_path).each do |f|
      next unless ::File.file?(f)

      if ::File.extname(f) == '.erb'
        f = nft_resolve_template(f, template_variables)
      end

      if !rules.has_key?(f) && ::File.extname(f) == '.rules'
        rules[f] = true
      end
    end

    rules.keys.sort.each do |f|
      nft_load_file(f)
    end
  end

  def nft_resolve_template(t, template_variables)
    f = ::File.basename(t, '.erb')
    Chef::Resource::Template.new(f, run_context).tap do |r|
      r.source t
      r.path f
      r.local true
      r.variables template_variables
    end.run_action(:create_if_missing)
    f
  end

  def nft_flush_rules
    nft_execute!("flush ruleset")
  end

  def nft_load_file(f)
    nft_execute!("-f #{f}")
  end

  def nft_execute!(action)
    command = "#{nft_path} #{action}"
    Chef::Log.info(command)
    shell_out!(command)
  end

  def nft_path
    @nft_path ||= which('nft')
  end
end
