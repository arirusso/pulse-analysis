module PulseAnalysis

  class Analysis

    DEFAULT_THRESHOLD = {
      amplitude: 0.7,
      length: 200
    }.freeze

    attr_reader :data, :periods, :sound

    def initialize(file_or_path, options = {})
      @threshold = {
        amplitude: DEFAULT_THRESHOLD[:amplitude],
        length: DEFAULT_THRESHOLD[:length]
      }
      @sound = Sound.load(file_or_path)
      validate_sound
    end

    def run
      @data = @sound.data
      populate_periods
    end

    private

    def populate_periods
      is_recording = false
      periods = []
      period_index = 0
      @data.each do |frame|
        if frame.abs < @threshold[:amplitude]
          is_recording = true
          periods[period_index] ||= 0
          periods[period_index] += 1
        else
          if is_recording
            is_recording = false
            period_index += 1
          end
        end
      end
      # remove the first and last periods in case recording wasn't started/
      # stopped in sync
      periods.shift
      periods.pop
      # remove periods that are below length threshold
      periods.reject! { |length| length < @threshold[:length] }
      @periods = periods
    end

    def warn(message)
      puts(message)
    end

    def convert_to_mono
      # Use left channel
      @sound.data = @sound.data.map(&:first)
    end

    def validate_sound
      if @sound.num_channels > 1
        warn "Input file is not mono, using first/left channel"
        convert_to_mono
      end
      if @sound.sample_rate < 48000
        raise "Sample rate must be at least 48000"
      end
    end

  end

end
