module PulseAnalysis

  class Analysis

    attr_reader :data

    def initialize(file_or_path, options = {})
      @sound = Sound.load(file_or_path)
      validate_sound
    end

    def amplitude_threshold
      0.7
    end

    def length_threshold
      200
    end

    def report
      run if @periods.nil?
      if @report.nil?
        @report = {}
        # periods.reject! { |length| length < length_threshold }
        # get differences
        # Audio file sample rate: 48000
        # Audio file length: 10m10s
        # Pulse rate: n
        # Total pulses: n
        # Max deviation: n samples (n ms)
      end
      @report
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
        if frame.abs < amplitude_threshold
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
      @periods = periods
    end

    def warn(message)
      puts(message)
    end

    def convert_to_mono
      @sound.data = @sound.data.map(&:first)
    end

    def validate_sound
      if @sound.num_channels > 1
        warn "Input file is not mono, using first channel"
        convert_to_mono
      end
      if @sound.sample_rate < 48000
        raise "Sample rate must be at least 48000"
      end
    end

  end

end
