#
# (c)2017 Ari Russo
# Apache 2.0 License
# https://github.com/arirusso/pulse-analyzer
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

  def self.report(file_or_path, options = {})
    analysis = Analysis.new(file_or_path, options)
    Report.new(analysis)
  end

end
