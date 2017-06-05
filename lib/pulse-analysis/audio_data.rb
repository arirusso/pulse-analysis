module PulseAnalysis

  class AudioData

    extend Forwardable

    def_delegators :@data, :[], :count, :each, :length, :max, :min, :size

    # @param [PulseAnalysis::Sound] sound
    def initialize(sound)
      @sound = sound
      @data = @sound.data
    end

    # Prepare the audio data for analysis
    # @return [Boolean]
    def prepare
      convert_to_mono if convert_to_mono?
      normalize if normalize?
      true
    end

    private

    # Should the audio data be normalized?
    # @return [Boolean]
    def normalize?
      headroom = 1.0 - @data.max
      headroom > 0.0
    end

    # Normalize the audio data
    # @return [Array<Float>]
    def normalize
      factor = 1.0 / @data.max
      @data.map! { |frame| frame * factor }
    end

    # Should the audio data be converted to a single channel?
    # @return [Boolean]
    def convert_to_mono?
      @sound.num_channels > 1
    end

    # Logic for converting a stereo sound to mono
    # @return [Array<Float>]
    def convert_to_mono
      # Use left channel
      @data = @data.map(&:first)
    end

  end

end
