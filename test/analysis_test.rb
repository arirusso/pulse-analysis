require "helper"

class PulseAnalysis::AnalysisTest < Minitest::Test

  context "Sound" do

    context "#run" do

      context "mono" do

        setup do
          @path = "test/media/1-mono-44100.wav"
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
