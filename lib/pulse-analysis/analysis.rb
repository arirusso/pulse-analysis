module PulseAnalysis

  class Analysis

    attr_reader :data

    def initialize(file_or_path, options = {})
      @sound = Sound.load(file_or_path)
    end

    def run
      @data = @sound.data
    end

  end

end
