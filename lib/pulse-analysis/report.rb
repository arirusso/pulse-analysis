module PulseAnalysis

  class Report

    attr_reader :analysis, :items

    # @param [PulseAnalysis::Analysis] analysis The analysis to report on.  Required that analysis has been run (see Analysis#run)
    def initialize(analysis)
      @analysis = analysis
      populate
    end

    def to_h
      {
        file: {
          path: @analysis.sound.audio_file.path.to_s
        },
        analysis: @items
      }
    end

    def inspect
      to_h.inspect
    end

    def num_samples_to_seconds(num_samples)
      num_samples / @analysis.sound.sample_rate
    end

    def num_samples_to_formatted_time(num_samples)
      min_sec = num_samples_to_seconds(num_samples).divmod(60)
      "#{min_sec[0]}m#{min_sec[1]}s"
    end

    def num_samples_to_millis(num_samples)
      ((num_samples.to_f / @analysis.sound.sample_rate) * 1000).round(2)
    end

    # Usable length of the audio file in the format (MMmSSs)
    # @return [String]
    def length_in_formatted_time
      @length_in_formatted_time ||= num_samples_to_formatted_time(@analysis.sound.size)
    end

    private

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
              value: num_samples_to_millis(@analysis.longest_period)
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
              value: num_samples_to_millis(@analysis.shortest_period)
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
              value: num_samples_to_millis(@analysis.average_period)
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
              value: num_samples_to_millis(@analysis.largest_abberation)
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
              value: num_samples_to_millis(@analysis.average_abberation)
            }
          ]
        }
        @items
      end
    end

  end

end
