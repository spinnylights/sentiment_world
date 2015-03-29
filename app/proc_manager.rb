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
    procs.each {|process| system "kill #{process.pid}"}
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
      system "kill #{process.pid}"
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
end
