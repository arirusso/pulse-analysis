module PulseAnalysis

  class Analysis

    MINIMUM_PULSES = 10
    MAX_BPM = 280

    attr_reader :abberations, :data, :periods, :sound

    # @param [PulseAnalysis::Sound] sound Sound to analyze
    # @param [Hash] options
    # @option options [Float] :amplitude_threshold Pulses above this amplitude will be analyzed
    def initialize(sound, options = {})
      @amplitude_threshold = options[:amplitude_threshold]
      populate_sound(sound)
      @data = AudioData.new(@sound)
    end

    # Run the analysis
    # @return [Boolean]
    def run
      prepare
      populate_periods
      validate
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
      @tempo_bpm ||= calculate_tempo_bpm
    end

    # Largest sequential abberation between pulses
    # @return [Integer]
    def largest_abberation
      @largest_abberation ||= abberations.max || 0
    end

    # Average sequential abberation between pulses
    # @return [Float]
    def average_abberation
      @average_abberation ||= calculate_average_abberation
    end

    # Non-zero pulse timing abberations derived from the periods
    # @return [Array<Integer>]
    def abberations
      @abberations ||= calculate_abberations
    end

    # The threshold (0..1) at which pulses will register as high
    # @return [Float]
    def amplitude_threshold
      @amplitude_threshold ||= calculate_amplitude_threshold
    end

    # Validate that analysis on the given data can produce
    # meaningful results
    # @return [Boolean]
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

    def prepare
      @data.prepare
    end

    # Calculate the average deviation from timing of one period to
    # the next
    # @return [Float]
    def calculate_average_abberation
      if abberations.empty?
        0.0
      else
        abberations.inject(&:+).to_f / abberations.count
      end
    end

    # Calculate the rhythmic tempo of the sound in beats per minute
    # @return [Float]
    def calculate_tempo_bpm
      seconds = average_period / @sound.sample_rate
      division = 4 # 16th notes
      60 / seconds / division
    end

    # Load the sound file and validate the data
    # @param [PulseAnalysis::Sound] sound Sound to analyze
    # @return [PulseAnalysis::Sound]
    def populate_sound(sound)
      @sound = sound
      @sound.validate_for_analysis
      @sound
    end

    # Populate the instance with abberations derived from the periods
    # @return [Array<Integer>]
    def calculate_abberations
      i = 0
      abberations = []
      @periods.each do |period|
        unless i.zero?
          last_period = @periods[i - 1]
          abberations << period - last_period
        end
        i += 1
      end
      abberations.pop
      abberations.shift
      abberations.map(&:abs)
    end

    # Calcuate the threshold at which pulses will register as high
    # This is derived from the audio data
    # @return [Float]
    def calculate_amplitude_threshold
      @data.max * 0.8
    end

    # Pulse detection will not detect if current period is shorter than this amount
    # @return [Integer]
    def min_period_length
      @sound.sample_rate * 60 / 4 / MAX_BPM
    end

    # Calculate periods between pulses
    # @return [Array<Integer>]
    def populate_periods
      is_high = true
      periods = []
      period_index = 0
      @data.each do |frame|
        if frame.abs < amplitude_threshold # if pulse is low
          is_high = false
        else
          # pulse is high
          if !is_high # last frame, the pulse was low
            # move to next period if length is past minimum
            if periods[period_index] >= min_period_length
              is_high = true
              period_index += 1
            end
          end
        end
        # count period length
        periods[period_index] ||= 0
        periods[period_index] += 1
      end
      prune_periods(periods)
      @periods = periods
    end

    # Remove any possibly malformed periods from the calculated set
    # @return [Array<Integer>]
    def prune_periods(periods)
      # remove the first and last periods in case recording wasn't started/
      # stopped in sync
      periods.shift
      periods.pop
      periods
    end

  end

end
