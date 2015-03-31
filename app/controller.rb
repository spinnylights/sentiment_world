require 'yaml'
require_relative './media_player'
require_relative './printer'

class Controller
  def initialize(args={})
    @config = load_config(args[:config_file])
    @media_player = args[:media_player]
    @printer      = args[:printer]
  end

  def process_keypress(key)
    entry = @config.select {|k,v| v[:key] == 'l'}
    tag = entry.keys[0]
    if @media_player then @media_player.play tag end
    if @printer then @printer.print end
  end

  private

  def load_config(config_file)
    config_text = File.open(config_file) { |f| f.read }
    YAML.load config_text
  end
end
