require 'minitest/autorun'
require_relative '../app/splitter.rb'

class SplitterTest < MiniTest::Test
  def test_splits_after_period_and_space
    test_string = "WAG-A-BAG. "
    expected = ["WAG-A-BAG. "]
    splitter = Splitter.new(test_string)
    assert_equal expected, splitter.split
  end

  def test_splits_after_newline
    test_string = "suffragettes\n"
    expected = ["suffragettes\n"]
    splitter = Splitter.new(test_string)
    assert_equal expected, splitter.split
  end

  def test_splits_after_period_and_newline
    test_string = "Lemons are lemons.\n"
    expected = ["Lemons are lemons.\n"]
    splitter = Splitter.new(test_string)
    assert_equal expected, splitter.split
  end

  def test_comprehensive_splitting
    test_string = "WAG-A-BAG. Lemons are lemons.\nsuffragettes\n"
    expected = ["WAG-A-BAG. ", "Lemons are lemons.\n", "suffragettes\n"]
    splitter = Splitter.new(test_string)
    assert_equal expected, splitter.split
  end
end
