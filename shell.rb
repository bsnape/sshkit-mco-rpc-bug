require 'net/ssh'
require 'logger'

class Shell

  def initialize(hostname, logger = Logger.new(STDOUT), options = {})
    @options  = { :user     => 'vagrant',
                  :password => 'vagrant' }.merge(options)
    @user     = options[:user]
    @hostname = hostname
    @logger   = logger # left out of options so it does not conflict with Net::SSH own options hash
  end

  def execute(command)
    ssh = Net::SSH.start(@hostname, @user, @options)
    @logger.info "Executing SSH command: #{command}"
    stdout      = ''
    stderr      = ''
    exit_code   = nil
    exit_signal = nil
    ssh.open_channel do |channel|
      channel.exec(command) do |ch, success|
        abort "FAILED: couldn't execute command: (#{command})" unless success
        channel.on_data { |ch, data| stdout += data }
        channel.on_extended_data { |ch, type, data| stderr += data }
        channel.on_request('exit-status') { |ch, data| exit_code = data.read_long }
        channel.on_request('exit-signal') { |ch, data| exit_signal = data.read_long }
      end
    end
    ssh.loop

    if stderr.size > 0
      @logger.error "#{exit_code} #{stderr}"
    elsif exit_code != 0
      @logger.info "SSH Completed with non-zero exit code '#{exit_code}'"
    end
    if stdout.size > 0
      @logger.info "#{stdout}"
    end

    stdout
  end

end
