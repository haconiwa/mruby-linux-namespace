module Namespace
  def self.setns(flag, options, &blk)
    if blk
      return nsenter(flag, options, &blk)
    end

    fd = options[:fd]
    pid = options[:pid]

    if fd
      setns_by_fd(fd, flag)
    elsif pid
      setns_by_pid(pid, flag)
    else
      raise ArgumentError, "Options :fd or :pid must be specified"
    end
  end

  def self.nsenter(flag, options, &blk)
    unless Object.const_get(:Process)
      raise NotImplementedError, "Namespace.nsenter depends on mruby-process"
    end

    pid = Process.fork do
      begin
        ::Namespace.setns(flag, options)
        blk.call
      rescue => e
        raise e
        exit(127)
      end
    end

    pid, s = Process.waitpid2 pid
    unless s.success?
      raise "nsenter process failed in some reason: PID=#{pid}, #{s.inspect}"
    end
    return s
  end
end
