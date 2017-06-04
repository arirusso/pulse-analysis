require "helper"

describe PulseAnalysis::Analysis do

  context "#run" do

    before(:each) do
      @media = File.join("spec", "media", "roland_r5_audioout_120bpm_88k.wav")
      @analysis = PulseAnalysis::Analysis.new(@media)
      @analysis.run
    end

    it "populates periods" do
      expect(@analysis.periods).to_not(be_nil)
      expect(@analysis.periods).to_not(be_empty)
    end

  end

end
