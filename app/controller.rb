require 'yaml'
require_relative './media_player'
require_relative './printer'

# The interface between keypresses and media events.
class Controller
  def initialize(args={})
    @config = load_config(args[:config_file])
    @media_player = args[:media_player]
    @printer      = args[:printer]
  end

  # Takes a char and uses it to look up a media file in the config, then plays
  # it if it has a media_player and outputs text if it has a printer.
  def process_keypress(char)
    if char == "\e" then exit 0 end
    entry = @config.select {|k,v| v[:key] == "#{char}"}
    tag = entry.keys[0]
    if tag.nil? then return end
    if @media_player then @media_player.play tag end
    if @printer then @printer.print end
  end

  private

  def load_config(config_file)
    config_text = File.open(config_file) { |f| f.read }
    YAML.load config_text
  end
end
