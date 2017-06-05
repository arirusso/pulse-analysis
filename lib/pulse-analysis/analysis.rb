module PulseAnalysis

  class Analysis

    MINIMUM_PULSES = 10

    attr_reader :data, :periods, :sound

    # @param [::File, String] file_or_path File or path to audio file to run analysis on
    def initialize(file_or_path)
      populate_sound(file_or_path)
      @data = @sound.data
    end

    # Run the analysis
    # @return [Boolean]
    def run
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

    def validate
      if valid?
        true
      else
        message = "Could not produce a valid analysis."
        raise(message)
      end
    end

    # Validate that the analysis has produced meaningful results
    # @return [Boolean]
    def valid?
      @periods.count > MINIMUM_PULSES
    end

    private

    # Load the sound file and validate the data
    # @param [::File, String] file_or_path File or path to audio file to run analysis on
    # @return [PulseAnalysis::Sound]
    def populate_sound(file_or_path)
      @sound = Sound.load(file_or_path)
      @sound.validate_for_analysis
      @sound
    end

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

    def amplitude_threshold
      @amplitude_threshold ||= @data.max * 0.8
    end

    def length_threshold(raw_periods)
      if @length_threshold.nil?
        average_period = raw_periods.inject(&:+).to_f / raw_periods.count
        @length_threshold = average_period * 0.8
      end
      @length_threshold
    end

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
      # remove the first and last periods in case recording wasn't started/
      # stopped in sync
      periods.shift
      periods.pop
      # remove periods that are below length threshold
      length = length_threshold(periods)
      periods.reject! { |period| period < length }
      @periods = periods
    end

    # Logic for converting a stereo sound to mono
    def convert_to_mono
      # Use left channel
      @sound.data = @sound.data.map(&:first)
    end

  end

end
