# Pulse Analysis

Inspired by the [Inner Clock Systems Litmus Test](http://innerclocksystems.com/New%20ICS%20Litmus.html)

## Installation

The package libsndfile ([link](https://github.com/erikd/libsndfile)) must be installed first.  It is available in *Homebrew*, *APT*, *Yum* as well as many other package managers. For those who wish to compile themselves or need more information, follow the link above for more information

Install the gem itself using

    gem install pulse-analysis

Or if you're using Bundler, add this to your Gemfile

    gem "pulse-analysis"

## Usage

#### Command Line

`pulse-analysis /path/to/a/sound/file.wav`

#### In Ruby

```ruby
require "pulse-analysis"

PulseAnalysis.new("/path/to/a/sound/file.wav")
```

## License

Licensed under Apache 2.0, See the file LICENSE

Copyright (c) 2017 [Ari Russo](http://arirusso.com)
