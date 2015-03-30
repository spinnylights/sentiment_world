require 'minitest/autorun'
require_relative '../app/printer.rb'

class PrinterTest < MiniTest::Test
  def test_print
    begin
      text_file = Tempfile.new 'text'
      text_file.write "sopapilla sauce. fishes ;P\n"
      text_file.close
      stdout_mock = MiniTest::Mock.new
      printer = Printer.new(file_path: text_file.path, output_stream: stdout_mock)
      stdout_mock.expect(:print, nil, [/sopapilla sauce\. || "fishes ;P\n/])
      printer.print
      stdout_mock.expect(:print, nil, [/sopapilla sauce\. || "fishes ;P\n/])
      printer.print
      stdout_mock.verify
    ensure
      text_file.unlink
    end
  end

  def test_print_works_indefinitely
    begin
      text_file = Tempfile.new 'text'
      text_file.write "fishes ;P\n"
      text_file.close
      stdout_mock = MiniTest::Mock.new
      printer = Printer.new(file_path: text_file.path, output_stream: stdout_mock)
      stdout_mock.expect(:print, nil, ["fishes ;P\n"])
      stdout_mock.expect(:print, nil, ["fishes ;P\n"])
      printer.print
      printer.print
      stdout_mock.verify
    ensure
      text_file.unlink
    end
  end
end
