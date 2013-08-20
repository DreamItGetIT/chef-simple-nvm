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

def version
  if new_resource.version.nil?
    raise "Version must be set"
  end
  new_resource.version
end

def make_default?
  new_resource.make_default == true
end

def source_nvm
  "source #{home_directory}/.nvm/nvm.sh"
end

def install_node!
  cmd = "bash -c '#{source_nvm} && nvm install #{version}'"
  install = Mixlib::ShellOut.new(cmd, cwd: home_directory, user: user)
  install.run_command
  install.error!
end

def make_default!
  cmd = "bash -c '#{source_nvm} && nvm alias default #{version}'"
  make_default = Mixlib::ShellOut.new(cmd, cwd: home_directory, user: user)
  make_default.run_command
  make_default.error!
end

action :install do
  install_node!
  if make_default?
    make_default!
  end

  new_resource.updated_by_last_action(true)
end

