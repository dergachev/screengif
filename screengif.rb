#!/usr/bin/env ruby

require 'RMagick'
include Magick

require_relative 'draw_progressbar.rb'
require_relative 'options.rb'
require_relative 'util.rb'

def call_ffmpeg(input_file, framerate, verbose)
  ffmpeg_loglevel = verbose ? 'verbose' : 'warning'
  # TODO: error handling
  return `ffmpeg -i '#{input_file}' -loglevel #{ffmpeg_loglevel} -r #{framerate} -f image2pipe -vcodec ppm - `
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

def handle_input(input_file, framerate, optionparser)
  if (input_file)
    $stderr.puts "Running ffmpeg with #{input_file}" if $verbose
    input = call_ffmpeg(input_file, framerate, $verbose)
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

input = handle_input(options.input_file, options.framerate, optionparser)
canvas = ImageList.new.from_blob(input)

if (!options.no_coalesce) 
  canvas = canvas.coalesce()
  $stderr.puts "Coalescing completed"
end

statusPrinter = Screengif::StatusPrinter.new($stderr)
canvas.each_with_index do |img,index|
  statusPrinter.printText("Processing image: #{index+1}/#{canvas.length}")
  img.delay = (index + 1  == canvas.length) ? options.delay_last : options.delay
  img.resize_to_fit!(options.maxwidth, options.maxheight)
  img.format = 'GIF'
  DrawProgressbar.draw(img, (index.to_f+1)/canvas.length) if (options.progressbar)
end
statusPrinter.done

# reduce down to 128 colors, disable dithering (equivalent to +dither)
canvas = canvas.quantize(128, RGBColorspace, NoDitherMethod) 
$stderr.puts "Quantization completed." if $verbose
canvas = canvas.optimize_layers(OptimizePlusLayer)
$stderr.puts "Rmagick processing completed." if $verbose

output = canvas.to_blob 
output = call_gifsicle(output) unless (options.no_gifsicle) 
handle_output(options.output_file, output, optionparser)
Screengif::ConversionStats.print(options.input_file, options.output_file, input, output)
