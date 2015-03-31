require 'minitest/autorun'
require 'yaml'
require_relative '../app/controller.rb'

class ControllerTest < MiniTest::Test
  def create_config_file
      config_hash = { 
        llama: {
          file: 'llama.mp3',
          type: 'audio',
          key: 'l'
        }
      }
      config_file = Tempfile.new('config')
      config_file.write config_hash.to_yaml
      config_file.rewind
      config_file
  end

  def test_sends_to_media_player_on_keypress
    begin
      config_file = create_config_file
      media_player_mock = MiniTest::Mock.new
      controller = Controller.new(
        config_file: config_file,
        media_player: media_player_mock
      )
      media_player_mock.expect :play, 1234, [:llama]
      controller.process_keypress('l')
      media_player_mock.verify
    ensure
      config_file.close!
    end
  end

  def test_sends_to_printer_on_keypress
    begin
      config_file = create_config_file
      printer_mock = MiniTest::Mock.new
      controller = Controller.new(
        config_file: config_file,
        printer: printer_mock
      )
      printer_mock.expect :print, nil
      controller.process_keypress('l')
      printer_mock.verify
    ensure
      config_file.close!
    end
  end
end
