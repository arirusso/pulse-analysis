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
require "pulse-analysis/audio_data"
require "pulse-analysis/file"
require "pulse-analysis/report"
require "pulse-analysis/sound"

module PulseAnalysis

  VERSION = "0.0.1"

  # Analyze the given audio file with the given options and generate a report
  # @param [::File, String] file_or_path File or path to audio file to run analysis on
  # @param [Hash] options
  # @option options [Float] :amplitude_threshold Pulses above this amplitude will be analyzed
  # @option options [Integer] :length_threshold Pulse periods longer than this value will be analyzed
  # @return [PulseAnalysis::Report]
  def self.report(file_or_path, options = {})
    analysis = Analysis.new(file_or_path, options)
    analysis.run
    Report.new(analysis)
  end

end
