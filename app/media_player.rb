require_relative './proc_manager.rb'

# Spawns media-playing processes. Makes use of a config file with a list of
# media files and their file types, stored by default at config/media_files.yaml. Collaborates with ProcManager by default.
class MediaPlayer
  def initialize(args)
    args = defaults.merge args
    @config      = load_config(args[:config_file])
    @proc_man    = args[:proc_man]
  end

  # Plays a media file. Takes its tag from the config file as the only
  # argument. Outputs error messages if there are issues with the config, but
  # doesn't raise an exception.
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
