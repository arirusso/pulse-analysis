module PulseAnalysis

  class Sound

    extend Forwardable

    attr_reader :audio_file, :data, :size
    def_delegators :@audio_file, :num_channels, :sample_rate

    # Load a sound from the given file path
    # @param [::File, String] file_or_path
    # @param [Hash] options
    # @option options [IO] logger
    # @return [Sound]
    def self.load(file_or_path, options = {})
      file = PulseAnalysis::File.new(file_or_path)
      new(file, options)
    end

    # @param [PulseAnalysis::File] audio_file
    # @param [Hash] options
    # @option options [IO] logger
    def initialize(audio_file, options = {})
      @audio_file = audio_file
      populate(options)
      report(options[:logger]) if options[:logger]
    end

    # Log a report about the sound
    # @param [IO] logger
    # @return [Boolean]
    def report(logger)
      logger.puts("Sound report for #{@audio_file.file}")
      logger.puts("  Sample rate: #{@audio_file.sample_rate}")
      logger.puts("  Channels: #{@audio_file.num_channels}")
      logger.puts("  File size: #{@audio_file.size}")
      true
    end

    # Validate that the sound is analyzable
    # @return [Boolean]
    def validate_for_analysis
      if sample_rate < 48000
        raise "Sample rate must be at least 48000"
      end
      true
    end

    private

    # Populate the sound meta/data
    # @param [Hash] options
    # @option options [IO] :logger
    # @return [Sound]
    def populate(options = {})
      @data = @audio_file.read(options)
      @size = data.size
      self
    end

  end

end
