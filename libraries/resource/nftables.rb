class Chef
  class Resource
    class Nftables < Chef::Resource
      resource_name :nftables

      default_action :deploy
      allowed_actions :deploy, :rollback

      property :deploy_path, String
      property :git_repo, String
      property :git_branch, String

      property :keystore_data_bag, String
      property :keystore_data_bag_item, String
      property :template_variables, Hash
    end
  end
end
