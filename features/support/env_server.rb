class Server
  include Aruba::Api

  DEFAULT_COMMAND = 'zassets serve'
  DEFAULT_HOST    = 'localhost'
  DEFAULT_PORT    = 9292

  attr_reader :exit_status

  def initialize
    @pid            = nil
    @exit_status    = nil
    @r_out, @w_out  = IO.pipe
    @r_err, @w_err  = IO.pipe
  end

  def uri_base
    'http://%s:%d' % [DEFAULT_HOST, DEFAULT_PORT]
  end

  def uri_for_path(path)
    [uri_base, path].join
  end

  def stdout
    @stdout ||= begin
      @w_out.close
      out = @r_out.read
      @r_out.close
      out
    end
  end

  def stderr
    @stderr ||= begin
      @w_err.close
      err = @r_err.read
      @r_err.close
      err
    end
  end

  def running?
    !!@pid
  end

  def start
      @pid = fork do
        $stdout.reopen @w_out
        $stderr.reopen @w_err

        exec DEFAULT_COMMAND
      end

      wait_ready
  end

  def wait_ready
    TCPSocket.new DEFAULT_HOST, DEFAULT_PORT
  rescue Errno::ECONNREFUSED
    sleep 0.05
    retry
  end

  def wait_stop
    pid, status = Process.waitpid2(@pid)

    if pid
      @exit_status = status.exitstatus || status.termsig
    end

    !!pid
  end

  def stop
    sig_int
    Process.wait(@pid)
    @pid = nil
  end

  def sig_int
    Process.kill('INT', @pid)
  end
end


Before('@server') do
  @_server = Server.new
end

After('@server') do
  @_server.stop if @_server.running?
end
