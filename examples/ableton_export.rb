#!/usr/bin/env ruby
$:.unshift(File.join("..", "lib"))

require "pulse-analysis"

report = PulseAnalysis.report("../spec/media/ableton_live_exportaudio_120bpm_48k.wav")
puts report.to_h
