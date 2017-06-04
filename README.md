# Pulse Analysis

Using an audio file, measure pulses for timing deviation

This would generally be used to measure the timing accuracy of drum machines, sequencers and other music electronics.  Inspired by the [Inner Clock Systems Litmus Test](http://innerclocksystems.com/New%20ICS%20Litmus.html)

## Installation

The package ([libsndfile](https://github.com/erikd/libsndfile)) must be installed first.  It is available in *Homebrew*, *APT*, *Yum* as well as many other package managers. For those who wish to compile themselves or need more information, follow the link above for more information

Install the gem itself using

    gem install pulse-analysis

Or if you're using Bundler, add this to your Gemfile

    gem "pulse-analysis"

## Usage

In keeping with conventions established by the Litmus Test, audio input files must be at least 48k sample rate.  It's recommended that an audio file around 10 minutes long with a pulse rate of 120bpm is used.

Mono audio files are recommended.  If a stereo file is used, only the left channel will be analyzed.

Sample audio files are included in the repository and can be found [here](https://github.com/arirusso/pulse-analysis/tree/master/spec/media)

#### Command Line

`pulse-analysis /path/to/a/sound/file.wav`

#### In Ruby

```ruby
require "pulse-analysis"

PulseAnalysis.report("/path/to/a/sound/file.wav")

=>

```

## Disclaimer

Please use the results generated with this program responsibly.  

With the subjective nature of the data at hand, this program is not meant to reflect poorly on any musicians, companies, hobbyists or anyone whose product has measurable timing.  After all, variation in timing may be desirable in some musical contexts.

Additionally, it's recommended that results be independently verified.  The settings of a particular device and recording environment can cause variation in timing accuracy.

## License

Licensed under Apache 2.0, See the file LICENSE

Copyright (c) 2017 [Ari Russo](http://arirusso.com)
