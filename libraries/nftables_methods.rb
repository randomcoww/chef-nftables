module NftablesMethods
  include Chef::Mixin::Which
  include Chef::Mixin::ShellOut

  def nft_flush_rules
    nft_execute!("flush ruleset")
  end

  def nft_load_rules_file(f)
    if ::File.file?(f) && f =~ /\.rules$/
      nft_execute!("-f #{f}")
    end
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
