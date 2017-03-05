class Chef
  class Resource
    class Nftables < Chef::Resource
      resource_name :nftables

      default_action :deploy
      allowed_actions :deploy, :rollback

      property :deploy_path, String
      property :git_repo, String
      property :git_branch, String
      property :template_variables, Hash
    end
  end
end
