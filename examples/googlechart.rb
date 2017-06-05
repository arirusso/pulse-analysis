#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

# Requires the googlecharts gem, not included in the Gemfile
require "googlecharts"
require "pulse-analysis"

# do analysis
r5 = PulseAnalysis.report("../spec/media/roland_r5_audioout_120bpm_88k.wav")

# chart analysis
chart = Gchart.new(
  type: "line",
  theme: :keynote,
  title: "Roland R5 Timing",
  legend: ["Roland R5"],
  data: [r5.analysis.abberations]
)

# save to file
chart.file
