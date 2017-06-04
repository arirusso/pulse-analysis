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

    # Usable length of the audio file in seconds
    # @return [Integer]
    def length_in_seconds
      @length_in_seconds ||= @sound.size / @sound.sample_rate
    end

    # Usable length of the audio file in the format (MMmSSs)
    # @return [String]
    def length_formatted
      if @length_formatted.nil?
        min_sec = length_in_seconds.divmod(60)
        @length_formatted = "#{min_sec[0]}m#{min_sec[1]}s"
      end
      @length_formatted
    end

    # Average number of samples between pulses
    # @return [Float]
    def average_period
      @average_period ||= @periods.inject(&:+).to_f / num_pulses
    end

    # Number of usable pulses in the audio file
    # @return [Integer]
    def num_pulses
      @num_pulses ||= @periods.count
    end

    # Longest number of samples between pulse
    # @return [Integer]
    def longest_period
      @longest_period ||= @periods.max
    end

    # Shortest number of samples between pulse
    # @return [Integer]
    def shortest_period
      @shortest_period ||= @periods.min
    end

    # Tempo of the audio file in beats per minute (BPM)
    # Assumes that the pulse is 16th notes as per the Innerclock
    # Litmus Test
    # @return [Float]
    def tempo_bpm
      if @tempo_bpm.nil?
        seconds = average_period / @sound.sample_rate
        division = 4 # 16th notes
        @tempo_bpm = 60 / seconds / division
      end
      @tempo_bpm
    end

    # Largest sequential abberation between pulses
    # @return [Integer]
    def largest_abberation
      abberations.max
    end

    # Average sequential abberation between pulses
    # @return [Float]
    def average_abberation
      abberations.inject(&:+).to_f / abberations.count
    end

    def abberations
      if @abberations.nil?
        i = 0
        abberations = @periods.map do |period|
          last_period = i >= 0 ? @periods[i - 1] : 0
          abberation = period - last_period
          i += 1
          abberation
        end
        abberations.reject!(&:zero?)
        @abberations = abberations.map(&:abs)
      end
      @abberations
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
