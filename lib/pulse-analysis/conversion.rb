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
    # to the sample rate.  (eg "1m20s")
    # @param [Integer] sample_rate Sample rate in hertz (eg 88200)
    # @param [Integer] num_samples
    # @return [String]
    def num_samples_to_formatted_time(sample_rate, num_samples)
      min_sec = num_samples_to_seconds(sample_rate, num_samples).divmod(60)
      "#{min_sec[0]}m#{min_sec[1]}s"
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
