module PulseAnalysis

  class Report

    extend Forwardable

    def_delegators :@report, :to_s
    attr_reader :analysis

    # @param [PulseAnalysis::Analysis] analysis The analysis to report on.  Required that analysis has been run (see Analysis#run)
    def initialize(analysis)
      @analysis = analysis
      populate
    end

    private

    # Popualate the report
    # @return [Hash]
    def populate
      if @analysis.periods.nil?
        raise "Analysis has not been run yet (use Analysis#run)"
      else
        @report = {}
        @report[:sample_rate] = @analysis.sound.sample_rate
        @report[:length] = @analysis.length_formatted
        @report[:num_pulses] = @analysis.num_pulses
        @report[:tempo_bpm] = @analysis.tempo_bpm
        @report[:average_period] = @analysis.average_period
        @report[:longest_period] = @analysis.longest_period
        @report[:shortest_period] = @analysis.shortest_period
        @report[:average_abberation] = @analysis.average_abberation
        @report[:largest_abberation] = @analysis.largest_abberation
        @report
      end
    end

  end

end
