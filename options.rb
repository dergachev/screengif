#!/usr/bin/env ruby

require 'optparse'
require 'ostruct'

$verbose = false

class OptionParse
    def self.parse(args)
        options = OpenStruct.new
        options.delay = 10
        options.delay_last = 50
        options.no_coalesce = false

        opts = OptionParser.new do |opts|
            opts.banner = "Screengif-rmagick.rb - Convert your screencast into a gif.\n" +
                          "Usage: screengif-rmagick.rb [options] [inputfile]\n" +
                          "Example: cat out.gif | ./screengif-rmagick.rb --delay 50 --delay-last 5 --no-coalesce"

            opts.separator ""
            opts.separator "Specific options:"

            opts.on("--no-coalesce", "Skip Magick::ImageList#coalesce() if input doesn't need it.") do
              options.no_coalesce = true
            end
            opts.on("--progressbar", "Overlay progress bar on the animation.") do
              options.progressbar = true
            end
            opts.on("-d", "--delay MS", Integer, "Animation frame delay, in tens of ms. (default: 10)") do |tens_of_ms|
              options.delay = tens_of_ms.to_i
            end
            opts.on("--delay-last MS", Integer, "Animation frame delay of last frame, in tens of ms. (default: 50)") do |tens_of_ms|
              options.delay_last = tens_of_ms.to_i
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
        opts.parse!(args)
        options
    end
end

