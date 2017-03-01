node.default['nftables']['pkg_update_command'] = "apt-get update -qqy"
node.default['nftables']['pkg_names'] = ['git', 'nftables']
node.default['nftables']['instances']['test'] = {
  'git_repo' => 'https://github.com/randomcoww/nftables-docker_config.git',
  'git_branch' => 'master',
  'template_variables' => {
    'docker_ip1' => '172.20.0.3',
    'docker_ip2' => '172.20.0.4'
  }
}
