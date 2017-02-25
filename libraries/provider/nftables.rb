class Chef
  class Provider
    class Nftables < Chef::Provider
      provides :nftables, os: "linux"

      def load_current_resource
        @current_resource = Chef::Resource::Nftables.new(new_resource.name)
        current_resource
      end

      def action_deploy
        converge_by("Deploy nftables: #{new_resource.name}") do
          deploy_revision(:deploy)
        end
      end

      def action_rollback
        converge_by("Rollback nftables: #{new_resource.name}") do
          deploy_revision(:rollback)
        end
      end

      private

      def deploy_revision(action)
        Chef::Resource::DeployRevision.new(new_resource.name, run_context).tap do |r|
          r.before_migrate ()
          r.before_restart ()
          r.before_symlink ()
          r.symlink_before_migrate ({})
          r.symlinks ({})
          r.branch new_resource.git_branch
          r.create_dirs_before_symlink ([])
          r.deploy_to new_resource.deploy_path
          r.keep_releases 2
          r.migrate false
          r.purge_before_symlink ([])
          r.repo new_resource.git_repo
          r.restart_command do
            nft_flush_rules
            ::Dir.chdir(release_path)
            ::Dir.entries(release_path).each do |f|
              nft_load_rules_file(f)
            end
          end
          r.rollback_on_error true
        end.run_action(action)
      end
    end
  end
end
