class ChefNftables
  class Resource
    class Rules < Chef::Resource
      resource_name :nftables_rules

      default_action :deploy
      allowed_actions :deploy, :rollback

      property :deploy_path, String
      property :git_repo, String
      property :git_branch, String
      property :template_variables, Hash
    end
  end
end
