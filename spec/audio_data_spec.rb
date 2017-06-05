require "helper"

describe PulseAnalysis::AudioData do

  before(:each) do
    @mono_media = File.join("spec", "media", "ableton_live_exportaudio_120bpm_48k.wav")
    @stereo_media = File.join("spec", "media", "expert-sleepers_disting_lfo_88k.wav")
  end

  context "#initialize" do

    before(:each) do
      @file = PulseAnalysis::File.new(@mono_media)
      @sound = PulseAnalysis::Sound.new(@file)
      @data = PulseAnalysis::AudioData.new(@sound)
    end

    it "populates" do
      expect(@data.length).to_not(be_nil)
    end

    it "has correct values" do
      expect(@data.length).to(eq(@data.size))
    end

  end

  context "#prepare" do

    context "mono" do

      before(:each) do
        @file = PulseAnalysis::File.new(@mono_media)
        @sound = PulseAnalysis::Sound.new(@file)
        @data = PulseAnalysis::AudioData.new(@sound)
        @data.prepare
      end

      it "normalizes" do
        5.times do
          i = rand(@data.size)
          expect(@data[i].abs).to(be >= @sound.data[i].abs)
        end
      end

    end

    context "stereo" do

      before(:each) do
        @file = PulseAnalysis::File.new(@stereo_media)
        @sound = PulseAnalysis::Sound.new(@file)
        @data = PulseAnalysis::AudioData.new(@sound)
        @data.prepare
      end

      it "normalizes" do
        5.times do
          i = rand(@data.size)
          expect(@data[0].abs).to(be >= @sound.data[0][0].abs)
        end
      end

      it "converts to mono" do
        expect(@data[0]).to_not(be_kind_of(Array))
        expect(@data[0]).to(be_kind_of(Float))
      end

    end

  end

end
