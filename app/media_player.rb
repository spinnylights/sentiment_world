require_relative './proc_manager.rb'

# Spawns media-playing processes. Makes use of a config file with a list of
# media files and their file types.
class MediaPlayer
  def initialize(args={})
    if args[:config_file]
      @config    = load_config(args[:config_file])
    end
    @proc_man    = args[:proc_man]
    @vid_playing = false
  end

  # Plays a media file. Takes its tag from the config file as the only
  # argument. Outputs error messages if there are issues with the config, but
  # doesn't raise an exception.
  def play(tag)
    file_info = @config[tag.to_sym]
    if file_info.nil?
      STDERR.puts "#{tag} was not found in config :("
      return
    end
    file_path = File.expand_path("../../media/#{file_info[:file]}", __FILE__)
    if @vid_playing
      @proc_man.killall
      system 'reset'
      @vid_playing = !@vid_playing
    elsif file_info[:type] == 'audio'
      @proc_man.toggle("#{tag}", "mplayer -really-quiet #{file_path}")
    elsif file_info[:type] == 'video'
      system 'clear'
      @proc_man.killall
      @proc_man.spawn("#{tag}", "vlc --quiet --crop 5:3 #{file_path}")
      @vid_playing = !@vid_playing
     # Thread.new {
     #   sleep 3
     #   if @proc_man.running?('waves')
     #     @proc_man.kill('waves')
     #     system 'reset'
     #     @vid_playing = false
     #   end
     # }.join
     # system 'clear'
    end
  end

  def killall
    @proc_man.killall
  end

  private

  def load_config(config_file)
    config_text = File.open(config_file) { |f| f.read }
    YAML.load config_text
  end
end
