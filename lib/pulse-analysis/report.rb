module PulseAnalysis

  class Report

    extend Forwardable

    def_delegators :@report, :to_s

    def initialize(analysis)
      @analysis = analysis
      populate
    end

    private

    # Usable length of the audio file in seconds
    # @return [Integer]
    def length_in_seconds
      @length_in_seconds ||= @analysis.sound.size / @analysis.sound.sample_rate
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
      @average_period ||= @analysis.periods.inject(&:+).to_f / num_pulses.to_f
    end

    # Number of usable pulses in the audio file
    # @return [Integer]
    def num_pulses
      @num_pulses ||= @analysis.periods.count
    end

    # Longest number of samples between pulse
    # @return [Integer]
    def longest_period
      @longest_period ||= @analysis.periods.max
    end

    # Shortest number of samples between pulse
    # @return [Integer]
    def shortest_period
      @shortest_period ||= @analysis.periods.min
    end

    # Tempo of the audio file in beats per minute (BPM)
    # Assumes that the pulse is 16th notes as per the Innerclock
    # Litmus Test
    # @return [Float]
    def tempo_bpm
      if @tempo_bpm.nil?
        seconds = average_period / @analysis.sound.sample_rate
        division = 4 # 16th notes
        @tempo_bpm = 60 / seconds / division
      end
      @tempo_bpm
    end

    def populate
      @analysis.run
      @report = {}
      @report[:sample_rate] = @analysis.sound.sample_rate
      @report[:length] = length_formatted
      @report[:num_pulses] = num_pulses
      @report[:tempo_bpm] = tempo_bpm
      @report[:average_period] = average_period
      @report[:longest_period] = longest_period
      @report[:shortest_period] = shortest_period

      # Max deviation: n samples (n ms)
      @report
    end

  end

end
