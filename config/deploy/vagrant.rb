set :user, 'vagrant'

ssh_options[:forward_agent] = true
ssh_options[:keys] = [File.join(ENV['HOME'], '.vagrant.d', 'insecure_private_key')]

server '192.168.2.10', :master, :primary => true
