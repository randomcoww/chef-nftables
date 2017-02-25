execute "pkg_update" do
  command node['nftables']['pkg_update_command']
  action :run
end

package node['nftables']['pkg_names'] do
  action :upgrade
end

node['nftables']['instances'].each do |name, v|
  nftables name do
    git_repo v['git_repo']
    git_branch v['git_branch']
    deploy_path ::File.join(Chef::Config[:file_cache_path], 'nftables', name)
    action :deploy
  end
end
