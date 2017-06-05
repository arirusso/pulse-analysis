# Pulse Analysis

Using an audio file, measure pulses for timing deviation

This would generally be used to measure the timing accuracy of drum machines, sequencers and other music electronics.  Inspired by the [Inner Clock Systems Litmus Test](http://innerclocksystems.com/New%20ICS%20Litmus.html)

## Installation

The package [libsndfile](https://github.com/erikd/libsndfile) must be installed first.  It's available in *Homebrew*, *APT*, *Yum* as well as many other package managers. For those who wish to compile themselves or need more information, follow the link above for more information

Install the gem itself using

```sh
gem install pulse-analysis
```

Or if you're using Bundler, add this to your Gemfile

```ruby
gem "pulse-analysis"
```

## Usage

### Input file

Pulse-Analysis operates on a single input audio file at a time.

#### Audio format

The audio file must be in an uncompressed format such as *WAV* or *AIFF*.

In keeping with conventions established by the Litmus Test, audio input files must be at least *48k* sample rate.  

Mono audio files are recommended.  If a stereo file is used, only the left channel will be analyzed.

#### Audio content

It's recommended that the audio file have a pulse rate of *16th notes* at *120 BPM* and be around *10 minutes long*. Using a single, consistent pulse-like sound (eg snare drum) striking 16th notes will produce the best results.

If it's not clear what's meant by this, example audio files are included in the repository and can be found [here](https://github.com/arirusso/pulse-analysis/tree/master/spec/media)

### Command Line

```sh
pulse-analysis /path/to/a/sound/file.wav
```

This will run the program and output something like

```sh
[/] Reading file /path/to/a/sound/file.wav Done!
[/] Running analysis Done!
[\] Generating Report Done!

+------------------------+-------------------------+-------------+
|                         Pulse Analysis                         |
+------------------------+-------------------------+-------------+
| Item                   | Value                                 |
+------------------------+-------------------------+-------------+
| Sample rate            | 88200 (Hertz)                         |
| Length                 | 4311 (Number of pulses) | 9m0s (Time) |
| Tempo                  | 119.9371 (BPM)                        |
| Longest period length  | 11289 (Samples)         | 127.99 (MS) |
| Shortest period length | 10687 (Samples)         | 121.17 (MS) |
| Average period length  | 11030.7838 (Samples)    | 125.07 (MS) |
| Largest abberation     | 543 (Samples)           | 6.16 (MS)   |
| Average abberation     | 155.5279 (Samples)      | 1.76 (MS)   |
+------------------------+-------------------------+-------------+
```

### In Ruby

```ruby
2.4.0 :002 > require "pulse-analysis"
 => true

2.4.0 :003 > PulseAnalysis.report("/path/to/a/sound/file.wav")
 => {
   :file=>{
     :path=>"/path/to/a/sound/file.wav"},
     :analysis=>[
       {
         :key=>:sample_rate,
         :description=>"Sample rate",
         :value=>{
           :unit=>"Hertz",
           :value=>88200
         }
       },
       {
         :key=>:tempo,
         :description=>"Tempo",
         :value=>{
           :unit=>"BPM",
           :value=>119.9371
         }
       },
       ...
```

## Disclaimer

Please remember to use results generated with this program responsibly.  

With the subjective nature of the data at hand, this program is not meant to reflect poorly on any musicians, companies, hobbyists or anyone whose product has measurable timing.  After all, variation in timing may be desirable in musical context.

Additionally, it's recommended that results be independently verified.  The configuration of a particular device or recording environment can cause variation in timing accuracy.

## License

Licensed under Apache 2.0, See the file LICENSE

Copyright (c) 2017 [Ari Russo](http://arirusso.com)
