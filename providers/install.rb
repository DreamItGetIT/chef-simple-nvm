def log(msg)
  Chef::Log.info(msg)
end

def user
  if new_resource.user.nil?
    raise "User must be set"
  end
  new_resource.user
end

def home_directory
  return @home_directory if @home_directory

  "/home/#{user}"
end

def nvm_installed?
  log "Checking for existing nvm installation for user #{user}"

  ::File.exists? ::File.join(home_directory, ".nvm")
end

def install_git!
  package("git").run_action(:install)
end

def install_curl!
  package("curl").run_action(:install)
end

def install_nvm!
  clone_cmd = "git clone git://github.com/creationix/nvm.git #{home_directory}/.nvm"
  clone = Mixlib::ShellOut.new(clone_cmd, cwd: home_directory, user: user)
  clone.run_command
  clone.error!

  install_cmd = "bash -c '#{home_directory}/.nvm/install.sh'"
  install = Mixlib::ShellOut.new(install_cmd, cwd: home_directory, user: user)
  install.run_command
  install.error!
end

action :install do
  if nvm_installed?
    log "NVM is already installed for user #{user}"
  else
    install_git!
    install_curl!
    install_nvm!

    new_resource.updated_by_last_action(true)
  end
end
