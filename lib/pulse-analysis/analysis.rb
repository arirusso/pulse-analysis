module PulseAnalysis

  class Analysis

    DEFAULT_THRESHOLD = {
      amplitude: 0.7,
      length: 200
    }.freeze

    attr_reader :data, :periods, :sound

    # @param [::File, String] file_or_path File or path to audio file to run analysis on
    # @param [Hash] options
    # @option options [Float] :amplitude_threshold Pulses above this amplitude will be analyzed
    # @option options [Integer] :length_threshold Pulse periods longer than this value will be analyzed
    def initialize(file_or_path, options = {})
      @threshold = {
        amplitude: options[:amplitude_threshold] || DEFAULT_THRESHOLD[:amplitude],
        length: options[:length_threshold] || DEFAULT_THRESHOLD[:length]
      }
      @sound = Sound.load(file_or_path)
      validate_sound
    end

    # Run the analysis
    # @return [Boolean]
    def run
      @data = @sound.data
      populate_periods
      true
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
      @largest_abberation ||= abberations.max || 0
    end

    # Average sequential abberation between pulses
    # @return [Float]
    def average_abberation
      if @average_abberation.nil?
        @average_abberation = if abberations.empty?
          0.0
        else
          abberations.inject(&:+).to_f / abberations.count
        end
      end
      @average_abberation
    end

    # Non-zero pulse timing abberations derived from the periods
    # @return [Array<Integer>]
    def abberations
      populate_abberations if @abberations.nil?
      @abberations
    end

    private

    # Populate the instance with abberations derived from the periods
    def populate_abberations
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
      periods.reject! { |period| period < @threshold[:length] }
      @periods = periods
    end

    def warn(message)
      puts(message)
    end

    # Logic for converting a stereo sound to mono
    def convert_to_mono
      # Use left channel
      @sound.data = @sound.data.map(&:first)
    end

    # Validate that the sound is analyzable
    # @return [Boolean]
    def validate_sound
      if @sound.num_channels > 1
        warn "Input file is not mono, using first/left channel"
        convert_to_mono
      end
      if @sound.sample_rate < 48000
        raise "Sample rate must be at least 48000"
      end
      true
    end

  end

end
