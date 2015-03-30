require 'minitest/autorun'
require_relative '../app/keypress_reader.rb'

class StreamDouble
  def getc
    'a'
  end

  def method_missing(*args)
  end
end

class KeypressReaderTest < MiniTest::Test
  def test_read
    reader = KeypressReader.new(StreamDouble.new)
    assert_equal 'a', reader.read
  end
end
