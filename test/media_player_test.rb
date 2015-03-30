require 'minitest/autorun'
require 'yaml'
require_relative '../app/media_player.rb'

class MediaPlayerTest < MiniTest::Test
  def test_playing_audio
    begin
      config_file = Tempfile.new('config')
      config_hash = {pretty_song: {file: 'herlequines.mp3', type: 'audio'}}
      config_file.write config_hash.to_yaml
      config_file.close
      procman_mock = MiniTest::Mock.new
      media_player = MediaPlayer.new({
        config_file: config_file, proc_man: procman_mock
      })
      procman_mock.expect :spawn, 1234, ['pretty_song', /mplayer.+herlequines.mp3.*/]
      media_player.play 'pretty_song'
      procman_mock.verify
    ensure
      config_file.unlink
    end
  end

  def test_playing_video
    begin
      config_file = Tempfile.new('config')
      config_hash = {pretty_vid: {file: 'waves.webm', type: 'video'}}
      config_file.write config_hash.to_yaml
      config_file.close
      procman_mock = MiniTest::Mock.new
      media_player = MediaPlayer.new(
        config_file: config_file, proc_man: procman_mock
      )
      procman_mock.expect :spawn, 1234, ['pretty_vid', /vlc.+waves.webm*/]
      media_player.play 'pretty_vid'
      procman_mock.verify
    ensure
      config_file.unlink
    end
  end

  def test_killall
    procman_mock = MiniTest::Mock.new
    media_player = MediaPlayer.new(proc_man: procman_mock)
    procman_mock.expect :killall, nil
    media_player.killall
    procman_mock.verify
  end
end
