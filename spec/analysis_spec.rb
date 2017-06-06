require "helper"

describe PulseAnalysis::Analysis do

  before(:each) do
    @media = File.join("spec", "media", "roland_r5_audioout_120bpm_88k.wav")
  end

  context "#run" do

    it "populates periods" do
      @sound = PulseAnalysis::Sound.load(@media)
      @analysis = PulseAnalysis::Analysis.new(@sound)
      @analysis.run
      expect(@analysis.periods).to_not(be_nil)
      expect(@analysis.periods).to_not(be_empty)
      expect(@analysis.periods).to(be_kind_of(Array))
      expect(@analysis.periods).to(all(be_kind_of(Integer)))
    end

  end

  context "#valid?" do

    before(:each) do
      @sound = Object.new
      expect(@sound).to(receive(:validate_for_analysis).once.and_return(true))
      expect(@sound).to(receive(:data).once.and_return([]))
      @analysis = PulseAnalysis::Analysis.new(@sound)
    end

    context "valid" do

      before(:each) do
        @analysis.instance_variable_set("@periods", (1..100).to_a)
      end

      it "returns true" do
        @sound = PulseAnalysis::Sound.load(@media)
        @analysis = PulseAnalysis::Analysis.new(@sound)
        @analysis.run
        expect(@analysis.valid?).to(be(true))
      end

    end

    context "invalid" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [])
      end

      it "returns false" do
        expect(@analysis.valid?).to(be(false))
      end

    end

  end

  context "#validate" do

    before(:each) do
      @sound = Object.new
      expect(@sound).to(receive(:validate_for_analysis).once.and_return(true))
      expect(@sound).to(receive(:data).once.and_return([]))
      @analysis = PulseAnalysis::Analysis.new(@sound)
    end

    context "valid" do

      before(:each) do
        @analysis.instance_variable_set("@periods", (1..100).to_a)
      end

      it "returns true" do
        expect(@analysis.validate).to(be(true))
      end

    end

    context "invalid" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [])
      end

      it "raises" do
        expect { @analysis.validate }.to(raise_exception(RuntimeError))
      end

    end

  end

  context "analysis items" do

    before(:each) do
      @sound = Object.new
      expect(@sound).to(receive(:validate_for_analysis).once.and_return(true))
      expect(@sound).to(receive(:data).once.and_return([]))
      @analysis = PulseAnalysis::Analysis.new(@sound)
    end

    context "#average_period" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [100, 200, 300, 400])
      end

      it "averages the period values" do
        expect(@analysis.average_period).to(eq(250))
      end

    end

    context "#num_pulses" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [270, 380, 490])
      end

      it "returns the number of periods" do
        expect(@analysis.num_pulses).to(eq(3))
      end

    end

    context "#longest_period" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [210, 320, 430, 540])
      end

      it "returns the highest period value" do
        expect(@analysis.longest_period).to(eq(540))
      end

    end

    context "#shortest_period" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [330, 440, 550, 660])
      end

      it "returns the lowest period value" do
        expect(@analysis.shortest_period).to(eq(330))
      end

    end

    context "#tempo_bpm" do

      before(:each) do
        expect(@sound).to(receive(:sample_rate).once.and_return(88200))
        @analysis.instance_variable_set("@periods", [1000, 1200, 1150, 1050])
      end

      it "returns the calculated tempo" do
        expect(@analysis.tempo_bpm).to(eq(1202.7272727272727))
      end

    end

    context "#largest_abberation" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [920, 920, 1200, 1150, 1050, 1050])
      end

      it "returns the largest sequential abberation" do
        expect(@analysis.largest_abberation).to(eq(280))
      end

    end

    context "#average_abberation" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [1100, 1100, 1300, 1250, 1150, 1150])
      end

      it "returns the average sequential abberation" do
        expect(@analysis.abberations).to(eq([200, 50, 100]))
        expect(@analysis.average_abberation).to(eq(116.66666666666667))
      end

    end

    context "#abberations" do

      before(:each) do
        @analysis.instance_variable_set("@periods", [900, 900, 920, 970, 940, 940])
      end

      it "returns the sequential abberations in order" do
        expect(@analysis.abberations).to(eq([20, 50, 30]))
      end

    end

    context "#amplitude_threshold" do

      before(:each) do
        @analysis.instance_variable_set("@data", [1204, 950, 1020, 1140])
      end

      it "returns the sequential abberations in order" do
        expect(@analysis.amplitude_threshold).to(eq(963.2))
      end

    end

  end

end
