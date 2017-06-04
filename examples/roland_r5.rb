#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "pulse-analysis"

report = PulseAnalysis.report("../spec/media/roland_r5_audioout_120bpm_88k.wav")
puts report.to_s
