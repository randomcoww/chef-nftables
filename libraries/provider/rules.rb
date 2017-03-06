class ChefNftables
  class Provider
    class Rules < Chef::Provider
      include Nftables

      provides :nftables_rules, os: "linux"
      use_inline_resources

      def load_current_resource
        @current_resource = ChefNftables::Resource::Rules.new(new_resource.name)
        current_resource
      end

      def action_deploy
        deploy_revision.run_action(:deploy)
      end

      def action_rollback
        deploy_revision.run_action(:rollback)
      end

      private

      def deploy_revision
        @deploy_revision ||= Chef::Resource::DeployRevision.new(new_resource.name, run_context).tap do |r|
          template_variables = new_resource.template_variables

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
            parser = ChefNftables::Provider::Rules::NftablesRules.new(template_variables)
            parser.load_rules_from_release_path
          end
          r.rollback_on_error true
        end
      end
    end
  end
end
