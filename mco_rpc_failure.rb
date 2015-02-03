require 'sshkit/dsl'
require 'sshkit'
require 'colorize'

host          = SSHKit::Host.new('vagrant@192.168.2.10')
host.password = 'vagrant'

on host do
  execute 'mco rpc service status service=httpd --json'
end
