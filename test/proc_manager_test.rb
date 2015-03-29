require 'minitest/autorun'
require_relative '../app/proc_manager.rb'

class TestProcManager < Minitest::Test
  def setup
    @procman = ProcManager.new
  end

  def assert(test, msg=nil)
    if msg.nil?
      super test, "procs = #{@procman.procs}"
    else
      super
    end
  end

  def refute(test, msg=nil)
    if msg.nil?
      super test, "procs = #{@procman.procs}"
    else
      super
    end
  end

  def test_running_procs
    @procman.spawn('sleep', 'sleep 1m')
    assert @procman.running_procs?
  end

  def test_kill
    @procman.spawn('sleep', 'sleep 1m')
    @procman.kill 'sleep'
    refute @procman.running? 'sleep'
  end

  def test_kill_all_procs
    @procman.spawn('sleep1', 'sleep 1m')
    @procman.spawn('sleep2', 'sleep 1m')
    @procman.killall
    refute @procman.running_procs?
  end

  def test_running
    @procman.spawn('sleep', 'sleep 1m')
    assert @procman.running? 'sleep'
  end

  def test_toggle_on
    @procman.toggle('sleep', 'sleep 1m')
    assert @procman.running? 'sleep'
  end

  def test_toggle_off
    @procman.toggle('sleep', 'sleep 1m')
    @procman.toggle('sleep', 'sleep 1m')
    refute @procman.running? 'sleep'
  end

  def test_whether_finished_procs_are_removed_from_list
    @procman.spawn('true', 'true')
    sleep 0.1
    refute @procman.running?('true'), "this fails sometimes due to race conditions; if it mostly passes don't worry about it"
  end

  def teardown
    @procman.killall
  end
end
