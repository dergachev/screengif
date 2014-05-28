#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'
require 'pp'

$verbose = false

module Screengif
  class Options
    def self.parse(args)
      options = OpenStruct.new

      options.framerate = 5
      options.delay = 10
      options.delay_last = 50
      options.no_coalesce = false
      options.progressbar = false
      options.input_file = nil
      options.output_file = nil
      options.no_gifsicle = false
      options.fuzz = 5

      # options.ffmpeg_inputfile = nil

      optionparser = OptionParser.new do |opts|
        opts.banner = "screengif.rb - Convert your screencast into a gif.\n" +
          "Usage:\n" + 
            "\tscreengif.rb [options] [--input FILENAME.mov] [--output OUTPUTFILE.gif]\n" +
          "Examples:\n" +
            "\t./screengif.rb --input demo.mov --output out.gif\n" +
            "\tcat somefile.gif | ./screengif.rb --progressbar --framerate 10 --delay 50 --delay-last 5 > out.gif\n"

        opts.separator ""
        opts.separator "Specific options:"

        opts.on("-i", "--input FILENAME.mov", "Use ffmpeg to convert FILENAME.mov into PPM image stream and process results.", 
                "If missing, will process PPM or GIF image stream from STDIN.") do |filename|
          if (File.exists?(filename))
            options.input_file = filename
            options.no_coalesce = true # ffmpeg's ppm output is already coalesced
          else
            $stderr.puts "Unable to open filename: #{filename}"
            puts opts
            exit 1
          end
        end
        opts.on("-o", "--output FILENAME.gif", "Output resulting GIF data to FILENAME.gif. (defaults to STDOUT).") do |filename|
          options.output_file  = filename
        end

        opts.on("-d", "--delay MS", Integer, "Animation frame delay, in tens of ms. (default: 10)") do |tens_of_ms|
          options.delay = tens_of_ms.to_i
        end

        opts.on("-p", "--progressbar", "Overlay progress bar on the animation.") do
          options.progressbar = true
        end

        opts.on("-d", "--delay MS", Integer, "Animation frame delay, in tens of ms. (default: 10)") do |tens_of_ms|
          options.delay = tens_of_ms.to_i
        end

        opts.on("--delay-last MS", Integer, "Animation frame delay of last frame, in tens of ms. (default: 50)") do |tens_of_ms|
          options.delay_last = tens_of_ms.to_i
        end

        opts.on("-r", "--framerate FPS", Integer, "Specify amount of frames per second to keep. (default: 5)") do |fps|
          options.framerate = fps.to_i
        end

        opts.on("-w", "--max-width PIXELS", Integer, "Output image max width, in pixels.") do |pixels|
          options.max_width = pixels.to_i
        end

        opts.on("--max-height PIXELS", Integer, "Output image max height, in pixels.") do |pixels|
          options.max_height = pixels.to_i
        end

        opts.on("--no-contrast", "Skip increasing contrast using imagemagick.") do
          options.nocontrast = true
        end

        opts.on("-f", "--fuzz PERCENT", Integer, "Imagemagick fuzz factor for color reduction. (default: 5%)") do |fuzz|
          options.fuzz = fuzz.to_i
        end

        opts.on("--no-coalesce", "Skip Magick::ImageList#coalesce() if input doesn't need it.") do
          options.no_coalesce = true
        end

        opts.on("--no-gifsicle", "Prevent filter the output through gifsicle. Greatly increases output file size.") do
          options.no_gifsicle = true
        end

        # Boilerplate
        opts.on_tail("-h", "--help", "Show this message") do
          puts opts
          exit
        end
        opts.on_tail("-v", "--verbose", "Verbose output") do
          $verbose = true
        end
        opts.on_tail("--version", "Show version") do
          puts "0.1"
          exit
        end
      end
      optionparser.parse!(args)
      return options, optionparser
    end
  end
end

