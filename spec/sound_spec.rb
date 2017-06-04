require "helper"

describe PulseAnalysis::Analysis do

  before(:each) do
    @mono_media = File.join("spec", "media", "ableton_live_exportaudio_120bpm_48k.wav")
    @stereo_media = File.join("spec", "media", "expert-sleepers_disting_lfo_88k.wav")
  end

  context "#populate" do

    context "mono" do

      before(:each) do
        @file = PulseAnalysis::File.new(@mono_media)
        @sound = PulseAnalysis::Sound.new(@file)
        @data = @sound.data
        @size = @sound.size
      end

      it "populates data" do
        expect(@data).to_not(be_nil)
        expect(@size).to_not(be_nil)
        expect(@data).to(be_kind_of(Array))
        expect(@data).to_not(be_empty)
        expect(@size).to(eq(@data.size))
      end

      it "has correct values" do
        expect(@data).to(all(be_a(Float)))
        expect(@data).to(all(be >= -1))
        expect(@data).to(all(be <= 1))
      end

    end

    context "stereo" do

      before(:each) do
        @file = PulseAnalysis::File.new(@stereo_media)
        @sound = PulseAnalysis::Sound.new(@file)
        @data = @sound.data
        @size = @sound.size
      end

      it "populates data" do
        expect(@data).to_not(be_nil)
        expect(@size).to_not(be_nil)
        expect(@data).to(be_kind_of(Array))
        expect(@data).to_not(be_empty)
        expect(@size).to(eq(@data.size))
      end

      it "has correct data" do
        expect(@data).to(all(be_a(Array)))
        expect(@data[0]).to(all(be >= -1))
        expect(@data[0]).to(all(be <= 1))
      end

    end

  end

  context "#report" do

    before(:each) do
      @logger = $>
      @sound = PulseAnalysis::Sound.load(@mono_media)
      expect(@logger).to(receive(:puts).exactly(4).and_return(true))
      @result = @sound.report(@logger)
    end

    it "does logging" do
      expect(@result).to_not(be_nil)
    end

  end

end
