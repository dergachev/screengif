#!/usr/bin/env ruby -w

# example usage: cat image.gif | ruby screengif-rmagick.rb > out.gif

require 'RMagick'
include Magick

require_relative 'draw_progressbar.rb'
require_relative 'options.rb'

$stderr.puts "\n\nStarting screengif-rmagick.rb\n"
options = OptionParse.parse(ARGV)

canvas = ImageList.new.from_blob(ARGF.read)

if (!options.no_coalesce) 
  canvas = canvas.coalesce()
  $stderr.puts "Coalescing completed"
end

canvas.each_with_index do |img,index| 
  $stderr.puts "Processing image: #{index+1}/#{canvas.length}"

  img.delay = (index == canvas.length - 1) ? options.delay_last : options.delay

  img.resize_to_fit!(600,600)
  img.format = 'GIF'

  if (options.progressbar)
    progressRatio = (index.to_f+1) / canvas.length
    DrawProgressbar.draw(img,progressRatio)
  end
end

# reduce down to 128 colors, disable dithering (equivalent to +dither)
canvas = canvas.quantize(128, RGBColorspace, NoDitherMethod) # equivalent of +dither
$stderr.puts "Quantization completed."

canvas = canvas.optimize_layers(OptimizePlusLayer)
$stderr.puts "Rmagick processing completed."

print canvas.to_blob 
