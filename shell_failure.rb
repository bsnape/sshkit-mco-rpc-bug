require_relative 'shell'

@shell = Shell.new('192.168.2.10')

@shell.execute 'mco rpc service status service=httpd --json'
