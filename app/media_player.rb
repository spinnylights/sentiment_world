require_relative './proc_manager.rb'

class MediaPlayer
  def initialize(args)
    args = defaults.merge args
    @config      = load_config(args[:config_file])
    @proc_man    = args[:proc_man]
  end

  def play(tag)
    file_info = @config[tag.to_sym]
    if file_info.nil?
      puts "#{tag} was not found in config :("
      return
    end
    file_path = File.expand_path("../../media/#{file_info[:file]}", __FILE__)
    if file_info[:type] == 'audio'
      @proc_man.spawn("#{tag}", "mplayer #{file_path}")
    elsif file_info[:type] == 'video'
      @proc_man.spawn("#{tag}", "vlc #{file_path}")
    else
      puts "#{file_info[:type]} is not a known file type :("
    end
  end

  def killall
    @proc_man.killall
  end

  private

  def defaults
    {
      config_file: File.expand_path(__FILE__, '../../config/media_files.yaml'),
      proc_man: ProcManager.new 
    }
  end

  def load_config(config_file)
    config_text = File.open(config_file) { |f| f.read }
    YAML.load config_text
  end
end
