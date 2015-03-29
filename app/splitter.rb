class Splitter
  attr_accessor :string
  def initialize(string)
    @string = string
  end

  # Splits a string up on periods followed by spaces, newlines, or periods 
  # followed by newlines. Uses #scan so the matched characters are preserved.
  # Appends a newline to the end of the string if there isn't one already.
  def split
    to_split = string
    unless to_split[-1] == "\n"
      to_split << "\n"
    end
    to_split.scan /.+\. |.+\.?\n/
  end
end
