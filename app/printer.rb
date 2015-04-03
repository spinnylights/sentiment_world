require_relative './splitter.rb'

# Pulls string from a file, makes a list from it with a Splitter, shuffles it, and pops an
# item from the list into an output stream when asked. By default, uses 
# '../config/printer.txt' relative to the file it's defined in and STDOUT.
class Printer
  def initialize(args={})
    args = defaults.merge args
    @file_path     = args[:file_path]
    @output_stream = args[:output_stream]
    @print_list    = []
  end

  # Pop a string off the list and print it to the output stream. If the
  # list is empty, regenerate it first.
  def print
    if @print_list.empty?
      @print_list = gen_print_list
    end
    to_print = @print_list.pop
    @output_stream.print to_print
    if to_print[-1] == "\n"
      @output_stream.print "\n"
    end
  end

  private

  def defaults
    {
      file_path: File.expand_path('../../config/printer.txt', __FILE__),
      output_stream: STDOUT
    }
  end

  def gen_print_list
    file_text = File.open(@file_path) {|f| f.read}
    Splitter.new(file_text).split.shuffle
  end
end
