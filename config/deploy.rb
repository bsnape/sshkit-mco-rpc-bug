desc 'capistrano 2 success case'
task :cap2_success do

  command = 'mco rpc -j puppet status'

  stdout = ''
  stderr = ''

  run(command, { :eof => true }) do |channel, stream, data|
    if stream == :out
      stdout += data
    else
      stderr += data
    end
  end

  puts "Got stdout data >>>#{stdout}<<<"
  puts "Got stderr data >>>#{stderr}<<<"
end


desc "capistrano 2 'failure' case (but actually works)"
task :cap2_failure do

  command = 'mco rpc service status service=httpd --json'

  stdout = ''
  stderr = ''

  run(command, { :eof => true }) do |channel, stream, data|
    if stream == :out
      stdout += data
    else
      stderr += data
    end
  end

  puts "Got stdout data >>>#{stdout}<<<"
  puts "Got stderr data >>>#{stderr}<<<"
end
