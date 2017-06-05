module PulseAnalysis

  class AudioData

    extend Forwardable

    def_delegators :@data, :[], :count, :each, :length, :max, :min, :size

    def initialize(sound)
      @sound = sound
      @data = @sound.data
    end

    def prepare
      convert_to_mono if convert_to_mono?
      normalize if normalize?
    end

    private

    def normalize?
      headroom = 1.0 - @data.max
      headroom > 0.0
    end

    def normalize
      factor = 1.0 / @data.max
      @data.map! { |frame| frame * factor }
    end

    def convert_to_mono?
      @sound.num_channels > 1
    end

    # Logic for converting a stereo sound to mono
    def convert_to_mono
      # Use left channel
      @data = @data.map(&:first)
    end

  end

end
