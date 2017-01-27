require "helper"

class PulseAnalyzer::SoundTest < Minitest::Test

  context "Sound" do

    context "#populate" do

      context "mono" do

        setup do
          @path = "test/media/1-mono-44100.wav"
          @file = PulseAnalyzer::File.new(@path)
          @sound = PulseAnalyzer::Sound.new(@file)
          @data = @sound.data
          @size = @sound.size
        end

        should "populate data" do
          refute_nil @data
          refute_nil @size
          assert @data.kind_of?(Array)
          refute_empty @data
          assert_equal @size, @data.size
          refute_empty @data
          assert @data.all? { |frame| frame.kind_of?(Float) }
          assert @data.all? { |frame| frame >= -1 }
          assert @data.all? { |frame| frame <= 1 }
        end

      end

      context "stereo" do

        setup do
          @path = "test/media/1-stereo-44100.wav"
          @file = PulseAnalyzer::File.new(@path)
          @sound = PulseAnalyzer::Sound.new(@file)
          @data = @sound.data
          @size = @sound.size
        end

        should "populate data" do
          refute_nil @data
          refute_nil @size
          assert @data.kind_of?(Array)
          refute_empty @data
          assert_equal @size, @data.size
          assert @data.all? { |frame_channels| frame_channels.kind_of?(Array) }
          assert @data.all? { |frame_channels| frame_channels.all? { |frame| frame.kind_of?(Float) } }
          assert @data.all? { |frame_channels| frame_channels.all? { |frame| frame >= -1 } }
          assert @data.all? { |frame_channels| frame_channels.all? { |frame| frame <= 1 } }
        end

      end

    end

    context "#report" do

      setup do
        @logger = $>
        @path = "test/media/1-mono-44100.wav"
        @sound = PulseAnalyzer::Sound.load(@path)
        @logger.expects(:puts).times(4)
      end

      teardown do
        @logger.unstub(:puts)
      end

      should "do logging" do
        assert @sound.report(@logger)
      end

    end

  end

end
