#!/usr/bin/env ruby -w

# usage:

require 'RMagick'
include Magick

canvas = ImageList.new.from_blob(ARGF.read)
progressbar = Draw.new

canvas.each_with_index do |img,index| 

  img.delay = (index == canvas.length - 1) ? 50 : 5
  ratio = (index.to_f+1) / canvas.length

  img.resize_to_fit!(600,600)
  img.format = 'GIF'

  wid = img.columns() - 3
  ht = img.rows() - 3 
  rectWid = 60
  rectHt = 20

  $stderr.puts "Processing image: #{index+1}/#{canvas.length}; ratio: #{ratio};  wxh: #{wid}x#{ht}"

  progressbar
    .fill('white')
    .stroke('black')
    .draw(img)
    .rectangle(wid-rectWid,ht-rectHt,wid,ht) 
  progressbar
    .fill('black')
    .pointsize(12)
    .stroke('transparent')
    .font_weight(BoldWeight)
    .gravity(NorthWestGravity)
    .text(wid-rectWid+4,ht-rectHt+5,"screengif")
  progressbar 
    .fill('black')
    .stroke('transparent')
    .rectangle(wid-rectWid,ht-rectHt,wid-rectWid*(1-ratio),ht) 
  progressbar.draw(img)

  maskedDraw = Draw.new
  maskedDraw.define_clip_path('clip') {
    maskedDraw
      .rectangle(wid-rectWid,ht-rectHt,wid-rectWid*(1-ratio),ht)
  }
  maskedDraw.push
  maskedDraw.clip_path('clip')
  maskedDraw
    .fill('white')
    .pointsize(12)
    .stroke('transparent')
    .font_weight(BoldWeight)
    .gravity(NorthWestGravity)
    .text(wid-rectWid+4,ht-rectHt+5,"screengif")
  maskedDraw.pop
  maskedDraw.draw(img)
end

# reduce down to 128 colors, disable dithering (equivalent to +dither)
canvas = canvas.quantize(128, RGBColorspace, NoDitherMethod) # equivalent of +dither
$stderr.puts "Quantization completed"
canvas = canvas.optimize_layers(OptimizePlusLayer)
$stderr.puts "Optimized layers"
print canvas.to_blob 
$stderr.puts "Done"

# canvas.write('out.gif')

exit
