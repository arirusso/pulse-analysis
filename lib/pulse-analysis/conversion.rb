module PulseAnalysis

  module Conversion

    extend self

    # Convert a quantity of samples to seconds with regard to the sample
    # rate
    # @param [Integer] sample_rate Sample rate in hertz (eg 88200)
    # @param [Integer] num_samples
    # @return [Float]
    def num_samples_to_seconds(sample_rate, num_samples)
      num_samples.to_f / sample_rate
    end

    # Convert a quantity of samples to a formatted time string with regard
    # to the sample rate.  (eg "1m20s", "2m22.4s"
    # @param [Integer] sample_rate Sample rate in hertz (eg 88200)
    # @param [Integer] num_samples
    # @return [String]
    def num_samples_to_formatted_time(sample_rate, num_samples)
      min, sec = *num_samples_to_seconds(sample_rate, num_samples).divmod(60)
      # convert seconds to int if it has no decimal value
      sec = sec.round(2)
      if !sec == 0 && sec.to_i % sec == 0
        sec = sec.to_i
      end
      # only include minutes if there is a value
      result = min > 0 ? "#{min}m" : ""
      result + "#{sec}s"
    end

    # Convert a quantity of samples to milliseconds with regard to the
    # sample rate
    # @param [Integer] sample_rate Sample rate in hertz (eg 88200)
    # @param [Integer] num_samples
    # @return [Float]
    def num_samples_to_millis(sample_rate, num_samples)
      (num_samples.to_f / sample_rate) * 1000
    end

  end

end
