node.default['nftables']['pkg_update_command'] = "apt-get update -qqy"
node.default['nftables']['pkg_names'] = ['git', 'nftables']
node.default['nftables']['instances']['ns'] = {
  'git_repo' => 'https://github.com/randomcoww/nftables-docker_config.git',
  'git_branch' => 'master'
}
