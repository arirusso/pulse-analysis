# Pulse Analysis
# Measure pulse timing accuracy in an audio file
#
# (c)2017 Ari Russo
# Apache 2.0 License
# https://github.com/arirusso/pulse-analysis
#

# libs
require "forwardable"
require "ruby-audio"

# classes
require "pulse-analysis/analysis"
require "pulse-analysis/file"
require "pulse-analysis/report"
require "pulse-analysis/sound"

module PulseAnalysis

  VERSION = "0.0.1"

  # Analyze the given audio file with the given options and generate a report
  # @param [::File, String] file_or_path File or path to audio file to run analysis on
  # @return [PulseAnalysis::Report]
  def self.report(file_or_path)
    analysis = Analysis.new(file_or_path)
    analysis.run
    Report.new(analysis)
  end

end
