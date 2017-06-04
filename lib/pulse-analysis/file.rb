module PulseAnalysis

  # An audio file
  class File

    extend Forwardable

    attr_reader :file, :num_channels, :size

    def_delegators :@file, :path

    # @param [::File, String] file_or_path
    def initialize(file_or_path)
      @file = file_or_path.kind_of?(::File) ? file_or_path : ::File.new(file_or_path)
      @sound = RubyAudio::Sound.open(@file)
      @size = ::File.size(@file)
      @num_channels = @sound.info.channels
    end

    def sample_rate
      @sample_rate ||= @sound.info.samplerate
    end

    # @param [Hash] options
    # @option options [IO] :logger
    # @return [Array<Array<Float>>, Array<Float>] File data
    def read(options = {})
      if logger = options[:logger]
        logger.puts("Reading audio file #{@file}")
      end
      buffer = RubyAudio::Buffer.float(@size, @num_channels)
      begin
        @sound.seek(0)
        @sound.read(buffer, @size)
        data = buffer.to_a
      rescue RubyAudio::Error
      end
      logger.puts("Finished reading audio file #{@file}") if logger
      data
    end

  end

end
