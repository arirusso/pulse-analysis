require "helper"

class PulseAnalysis::AnalysisTest < Minitest::Test

  context "Sound" do

    context "#run" do

      context "mono" do

        setup do
          @path = "test/media/live_120bpm_48k.wav"
          @analysis = PulseAnalysis::Analysis.new(@path)
          @analysis.run
        end

        should "populate data" do
          refute_nil @analysis
        end

      end

      context "stereo" do


      end

    end

  end

end
