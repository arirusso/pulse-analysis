# Pulse Analysis

Using an audio file, measure pulses for timing deviation

Inspired by the [Inner Clock Systems Litmus Test](http://innerclocksystems.com/New%20ICS%20Litmus.html)

## Installation

The package libsndfile ([link](https://github.com/erikd/libsndfile)) must be installed first.  It is available in *Homebrew*, *APT*, *Yum* as well as many other package managers. For those who wish to compile themselves or need more information, follow the link above for more information

Install the gem itself using

    gem install pulse-analysis

Or if you're using Bundler, add this to your Gemfile

    gem "pulse-analysis"

## Usage

Audio input files must be at least 48k sample rate

It's recommended that an audio file around 10 minutes long with a pulse rate of 120bpm is used

A sample audio file can be found [here]

#### Command Line

`pulse-analysis /path/to/a/sound/file.wav`

#### In Ruby

```ruby
require "pulse-analysis"

PulseAnalysis.report("/path/to/a/sound/file.wav")

=>

```

## License

Licensed under Apache 2.0, See the file LICENSE

Copyright (c) 2017 [Ari Russo](http://arirusso.com)
