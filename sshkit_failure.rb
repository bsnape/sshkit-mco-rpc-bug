require 'sshkit/dsl'
require 'sshkit'
require 'colorize'

# !! alternate authentication and execution

# host          = SSHKit::Host.new('vagrant@192.168.2.10')
# host.password = 'vagrant'
#
# on host do
#   execute 'mco rpc service status service=httpd --json'
# end


SSHKit::Backend::Netssh.configure do |ssh|
  ssh.connection_timeout = 30
  ssh.ssh_options = {
    user: 'vagrant',
    keys:[File.join(ENV['HOME'], '.vagrant.d', 'insecure_private_key')],
    forward_agent: true,
    auth_methods: %w(publickey password)
  }
end

on '192.168.2.10' do
  execute 'mco rpc service status service=httpd --json'
end
