#!/usr/bin/env ruby

class DrawProgressbar
  def self.draw(img,ratio)
    wid = img.columns() - 3
    ht = img.rows() - 3 
    rectWid = 60
    rectHt = 20

    progressbar = Draw.new

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
end
