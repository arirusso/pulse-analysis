module PulseAnalysis

  class Analysis

    def initialize(file_or_path, options = {})
      @sound = Sound.load(file_or_path)
    end

    def run
      p @sound.data.size
    end

  end

end
