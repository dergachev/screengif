#!/usr/bin/env ruby

require 'RMagick'
include Magick

require_relative 'draw_progressbar.rb'
require_relative 'options.rb'
require_relative 'util.rb'

def call_ffmpeg(input_file, options, verbose)
  ffmpeg_loglevel = verbose ? 'verbose' : 'warning'
  if options.framerate
    ffmpeg_framerate = "-r #{options.framerate}"
  end

  if options.max_width || options.max_height
    options.max_width ||= "-1"
    options.max_height ||= "-1"
    ffmpeg_resize = "-vf scale=#{options.max_width}:#{options.max_height} -sws_flags lanczos"
  end
  # TODO: error handling
  return `ffmpeg -i '#{input_file}' -loglevel #{ffmpeg_loglevel} #{ffmpeg_framerate} #{ffmpeg_resize} -f image2pipe -vcodec ppm - `
end

def call_gifsicle(data)
  $stderr.puts "Filtering output through gifsicle" if $verbose
  # TODO: error handling
  result = ''
  # popen is for system calls that require setting STDIN
  IO.popen('gifsicle --loop --optimize=3 --multifile -', 'r+') do |f|
    f.write(data)
    f.close_write
    result = f.read
  end
  return result
end

def handle_input(input_file, options, optionparser)
  if (input_file)
    $stderr.puts "Running ffmpeg with #{input_file}" if $verbose
    input = call_ffmpeg(input_file, options, $verbose)
  elsif !$stdin.tty? # we are being piped to
    $stderr.puts "Reading input from STDIN." if $verbose
    input = STDIN.read
  else
    $stderr.puts "No input file available."
    puts optionparser
    exit 1
  end
  return input
end

def handle_output(output_file, output, optionparser)
  if (output_file)
    File.open(output_file, 'w') do |f|
      f.puts output
    end
  elsif !STDOUT.tty?
    $stderr.puts "Sending output to STDOUT" if $verbose
    puts output
  else
    $stderr.puts "Error: No output destination available."
    puts optionparser
    exit 1
  end
end

options,optionparser = Screengif::Options.parse(ARGV)
$startTime = Time.now

input = handle_input(options.input_file, options, optionparser)
canvas = ImageList.new.from_blob(input)

if (!options.no_coalesce)
  $stderr.puts "Beginning imagemagick coalescing..." if $verbose
  canvas = canvas.coalesce()
  $stderr.puts "Coalescing completed" if $verbose
end

statusPrinter = Screengif::StatusPrinter.new($stderr)
canvas.each_with_index do |img,index|
  statusPrinter.printText("Processing image: #{index+1}/#{canvas.length}")
  img.delay = (index + 1  == canvas.length) ? options.delay_last : options.delay
  img.format = 'GIF'
  img.fuzz = "#{options.fuzz}%" if options.fuzz > 0
  unless options.nocontrast
    img = img.contrast(true)
    img = img.white_threshold(QuantumRange * 0.99)
    # img = img.level(QuantumRange * 0.05, QuantumRange * 0.95)
  end
  DrawProgressbar.draw(img, (index.to_f+1)/canvas.length) if (options.progressbar)
  canvas[index] = img
end
statusPrinter.done

# see http://stackoverflow.com/questions/958681/how-to-deal-with-memory-leaks-in-rmagick-in-ruby
GC.start

# Reduce down to 256 colors (as required by GIF), disable dithering (equivalent to +dither)
$stderr.puts "Beginning quantization... (takes a while)" if $verbose
canvas = canvas.quantize(256, RGBColorspace, NoDitherMethod)
$stderr.puts "Quantization completed." if $verbose

$stderr.puts "Beginning rmagick OptimizePlusLayer..." if $verbose
canvas = canvas.optimize_layers(OptimizePlusLayer)
$stderr.puts "Beginning rmagick OptimizeTransLayer..." if $verbose
canvas = canvas.optimize_layers(OptimizeTransLayer)

$stderr.puts "Rmagick processing completed. Outputting results..." if $verbose
output = canvas.to_blob 

GC.start

output = call_gifsicle(output) unless (options.no_gifsicle) 

handle_output(options.output_file, output, optionparser)
Screengif::ConversionStats.print(options.input_file, options.output_file, input, output)
