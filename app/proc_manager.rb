class ProcManager
  attr_reader :procs

  def initialize
    @procs = []
  end

  def spawn(name, cmd)
    pid = Kernel.spawn(cmd, [:out, :err]=>'/dev/null')
    Process.detach pid
    @procs << ProcContainer.new(name, pid)
    pid
  end

  def kill(name)
    procs = @procs.select {|process| process.name == name}
    procs.each do |process|
      Process.detach process.pid
      system "kill #{process.pid}"
    end
    @procs.delete_if {|process| process.name == name}
  end

  def toggle(name, cmd)
    if running? name
      kill name
    else
      spawn(name, cmd)
    end
  end

  def killall
    until @procs.empty?
      process = @procs.pop
      Process.detach process.pid
      system "kill #{process.pid} 1>/dev/null 2>&1"
    end
  end

  def running?(name)
    @procs.any? {|process| process.name == name}
  end

  def running_procs?
    !@procs.empty?
  end

  private

  ProcContainer = Struct.new(:name, :pid)

  def spawn_garbage_collector
    thread = Thread.new do
      while true
        @procs.each do |process|
          if Process.wait(process.pid, Process::WNOHANG)
            @procs.delete process
          end
        end
        sleep 0.0001
      end
    end
    thread
  end
end
