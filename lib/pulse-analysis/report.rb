module PulseAnalysis

  class Report

    extend Forwardable

    def_delegators :@report, :to_s

    def initialize(analysis)
      @analysis = analysis
      populate
    end

    private

    def length_in_seconds
      @analysis.sound.size / @analysis.sound.sample_rate
    end

    def length_formatted
      min_sec = length_in_seconds.divmod(60)
      "#{min_sec[0]}m#{min_sec[1]}s"
    end

    def pulse_rate
      @analysis.periods.inject(&:+).to_f / num_pulses.to_f
    end

    def num_pulses
      @analysis.periods.count
    end

    def populate
      @analysis.run
      @report = {}
      @report[:sample_rate] = @analysis.sound.sample_rate
      @report[:length] = length_formatted
      @report[:num_pulses] = num_pulses
      @report[:pulse_rate] = pulse_rate
      # get differences

      # Pulse rate: n
      # Total pulses: n
      # Max deviation: n samples (n ms)
      @report
    end

  end

end
