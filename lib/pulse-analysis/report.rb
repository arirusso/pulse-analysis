module PulseAnalysis

  class Report

    attr_reader :analysis, :items

    # @param [PulseAnalysis::Analysis] analysis The analysis to report on.  Required that analysis has been run (see Analysis#run)
    def initialize(analysis)
      @analysis = analysis
      populate
    end

    # Convert the report to a hash
    # @return [Hash]
    def to_h
      {
        file: {
          path: @analysis.sound.audio_file.path.to_s
        },
        analysis: @items
      }
    end

    # Override Object#inspect to not include the large audio data
    # @return [String]
    def inspect
      to_h.inspect
    end

    private

    # Usable length of the audio file in the format (MMmSSs)
    # @return [String]
    def length_in_formatted_time
      @length_in_formatted_time ||= Conversion.num_samples_to_formatted_time(@analysis.sound.sample_rate, @analysis.sound.size)
    end

    # Popualate the report
    # @return [Array]
    def populate
      if @analysis.periods.nil?
        raise "Analysis has not been run yet (use Analysis#run)"
      else
        @items = []
        @items << {
          key: :sample_rate,
          description: "Sample rate",
          value: {
            unit: "Hertz",
            value: @analysis.sound.sample_rate
          }
        }
        @items << {
          key: :length,
          description: "Length",
          value: [
            {
              unit: "Number of pulses",
              value: @analysis.num_pulses
            },
            {
              unit: "Time",
              value: length_in_formatted_time
            }
          ]
        }
        @items << {
          key: :tempo,
          description: "Tempo",
          value: {
            unit: "BPM",
            value: @analysis.tempo_bpm.round(4)
          }
        }
        @items << {
          key: :longest_period,
          description: "Longest period length",
          value: [
            {
              unit: "Samples",
              value: @analysis.longest_period
            },
            {
              unit: "ms",
              value: Conversion.num_samples_to_millis(@analysis.sound.sample_rate, @analysis.longest_period).round(2)
            }
          ]
        }
        @items << {
          key: :shortest_period,
          description: "Shortest period length",
          value: [
            {
              unit: "Samples",
              value: @analysis.shortest_period
            },
            {
              unit: "ms",
              value: Conversion.num_samples_to_millis(@analysis.sound.sample_rate, @analysis.shortest_period).round(2)
            }
          ]
        }
        @items << {
          key: :average_period,
          description: "Average period length",
          value: [
            {
              unit: "Samples",
              value: @analysis.average_period.round(4)
            },
            {
              unit: "ms",
              value: Conversion.num_samples_to_millis(@analysis.sound.sample_rate, @analysis.average_period).round(2)
            }
          ]
        }
        @items << {
          key: :largest_abberation,
          description: "Largest abberation",
          value: [
            {
              unit: "Samples",
              value: @analysis.largest_abberation
            },
            {
              unit: "ms",
              value: Conversion.num_samples_to_millis(@analysis.sound.sample_rate, @analysis.largest_abberation).round(2)
            }
          ]
        }
        @items << {
          key: :average_abberation,
          description: "Average abberation",
          value: [
            {
              unit: "Samples",
              value: @analysis.average_abberation.round(4)
            },
            {
              unit: "ms",
              value: Conversion.num_samples_to_millis(@analysis.sound.sample_rate, @analysis.average_abberation).round(2)
            }
          ]
        }
        @items
      end
    end

  end

end
