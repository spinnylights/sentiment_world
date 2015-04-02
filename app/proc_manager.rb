# Used to spawn, track, and dispose of system processes. In particular, this
# class is used to manage the media-playing processes triggered by keypresses
# while the app is running.
class ProcManager
  attr_reader :procs

  def initialize
    @procs = []
  end

  # "name" is an arbitrary string of your choice used to track the process
  # internally. "cmd" is a string containing the command you wish to pass
  # to the underlying shell.
  def spawn(name, cmd, opts={})
    pid = 0
    if opts[:mute_stdout]
      pid = Kernel.spawn(cmd, [:out, :err]=>'/dev/null')
    else
      pid = Kernel.spawn(cmd, [:err]=>'/dev/null')
    end
    @procs << ProcContainer.new(name, pid)
    pid
  end

  # Kills procs by what you named them. If you gave them all the same name,
  # they'll all be killed.
  def kill(name)
    procs = @procs.select {|process| process.name == name}
    procs.each do |process|
      Process.detach process.pid
      system "kill #{process.pid}"
    end
    @procs.delete_if {|process| process.name == name}
  end

  # Spawns a proc if it's not already running, and kills it if it is. Searches
  # by name.
  def toggle(name, cmd, opts={})
    if running? name
      kill name
    else
      spawn(name, cmd, opts)
    end
  end

  # Kills all procs the manager is aware of.
  def killall
    until @procs.empty?
      process = @procs.pop
      Process.detach process.pid
      system "kill #{process.pid} 1>/dev/null 2>&1"
    end
  end

  # Checks to see if a proc is currently running.
  def running?(name)
    collect_garbage
    @procs.any? {|process| process.name == name}
  end

  # Checks to see if any procs are currently running.
  def running_procs?
    collect_garbage
    !@procs.empty?
  end

  private

  ProcContainer = Struct.new(:name, :pid)

  def collect_garbage
    @procs.each do |process|
      if Process.wait(process.pid, Process::WNOHANG)
        @procs.delete process
      end
    end
  end
end
