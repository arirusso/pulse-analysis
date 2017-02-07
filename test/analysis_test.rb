require "helper"

class PulseAnalysis::AnalysisTest < Minitest::Test

  context "Sound" do

    context "#initialize" do

      context "mono" do
      end

      context "stereo" do

        should "warn" do
        end

        should "convert to mono" do
        end

      end

    end

    context "#run" do

      setup do
        @path = "test/media/roland_r5_audioout_120bpm_88k.wav"
        @analysis = PulseAnalysis::Analysis.new(@path)
        @report = @analysis.run
      end

      should "populate report" do
        refute_nil @report
      end

    end

  end

end
