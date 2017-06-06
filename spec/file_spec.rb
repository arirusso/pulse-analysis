require "helper"

describe PulseAnalysis::Analysis do

  before(:each) do
    @mono_media = File.join("spec", "media", "ableton_live_exportaudio_120bpm_48k.wav")
    @stereo_media = File.join("spec", "media", "expert-sleepers_disting_lfo_60bpm_88k.wav")
  end

  context "#initialize" do

    context "mono" do

      before(:each) do
        @file = PulseAnalysis::File.new(@mono_media)
      end

      it "populates" do
        expect(@file).to_not(be_nil)
        expect(@file.num_channels).to_not(be_nil)
        expect(@file.sample_rate).to_not(be_nil)
        expect(@file.file).to_not(be_nil)
        expect(@file.size).to_not(be_nil)
      end

      it "has correct information" do
        expect(@file.num_channels).to(eq(1))
        expect(@file.sample_rate.to_i).to(eq(48000))
        expect(@file.path).to(eq(@mono_media))
        expect(@file.size).to(eq(File.size(@mono_media)))
      end

    end

    context "stereo" do

      before(:each) do
        @file_obj = File.new(@stereo_media)
        @file = PulseAnalysis::File.new(@file_obj)
      end

      it "populates" do
        expect(@file).to_not(be_nil)
        expect(@file.num_channels).to_not(be_nil)
        expect(@file.sample_rate).to_not(be_nil)
        expect(@file.file).to_not(be_nil)
        expect(@file.size).to_not(be_nil)
      end

      it "has correct information" do
        expect(@file.num_channels).to(eq(2))
        expect(@file.sample_rate.to_i).to(eq(88200))
        expect(@file.path).to(eq(@stereo_media))
        expect(@file.size).to(eq(File.size(@stereo_media)))
      end

    end

  end

  context "#read" do

    context "mono" do

      before(:each) do
        @file = PulseAnalysis::File.new(@mono_media)
        @data = @file.read
      end

      it "populates data" do
        expect(@data).to_not(be_nil)
        expect(@data).to(be_kind_of(Array))
        expect(@data).to_not(be_empty)
      end

      it "has correct data" do
        expect(@data).to(all(be_a(Float)))
        expect(@data).to(all(be >= -1))
        expect(@data).to(all(be <= 1))
      end

    end

    context "stereo" do

      before(:each) do
        @file = PulseAnalysis::File.new(@stereo_media)
        @data = @file.read
      end

      it "populates data" do
        expect(@data).to_not(be_nil)
        expect(@data).to(be_kind_of(Array))
        expect(@data).to_not(be_empty)
      end

      it "has correct data" do
        expect(@data).to(all(be_a(Array)))
        expect(@data[0]).to(all(be >= -1))
        expect(@data[0]).to(all(be <= 1))
      end

    end

  end

end
