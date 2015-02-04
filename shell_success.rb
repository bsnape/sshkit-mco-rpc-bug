require_relative 'shell'

@shell = Shell.new('192.168.2.10')

@shell.execute 'mco service status httpd'
