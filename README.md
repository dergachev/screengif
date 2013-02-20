# Screengif

A commandline tool to convert SCREENCAST.mov into ANIMATED.gif

Here's what happens when you apply it to [demo.mov](https://raw.github.com/dergachev/screengif/master/demo.mov)

```bash
bash screengif.sh demo.mov out.gif
```

![](https://raw.github.com/dergachev/screengif/master/demo.gif)

## Installation

The following works with OS X and homebrew: 

```bash
git clone https://github.com/dergachev/screengif.git
cd screengif
brew cask install x-quartz

# x-quartz is a dependency for gifsicle, no longer installed starting on 10.8
brew cask install x-quartz 
open /usr/local/Cellar/x-quartz/2.7.4/XQuartz.pkg # runs the XQuartz installer

brew install ffmpeg imagemagick gifsicle
# brew install ghostscript # not sure if this is necessary
```

## Resources

### Related solutions

* http://freezeframe.chrisantonellis.com/ (js library to freeze/play gifs)
* https://gist.github.com/dergachev/4627207
* http://askubuntu.com/questions/107726/how-to-create-animated-gif-images-of-a-screencast

### RMagick

* http://railscasts.com/episodes/374-image-manipulation?view=asciicast
* http://ruby.bastardsbook.com/chapters/image-manipulation/
* https://github.com/markandrus/imgswiss/blob/master/pipeline.rb (ffmpeg -> imagemagick via rmagick -> gif)

* http://www.imagemagick.org/RMagick/doc/info.html#format
* http://www.imagemagick.org/RMagick/doc/draw.html#rectangle
* http://www.imagemagick.org/RMagick/doc/constants.html#GravityType
* http://www.simplesystems.org/RMagick/doc/optequiv.html
* http://www.imagemagick.org/RMagick/doc/ilist.html
* http://www.imagemagick.org/RMagick/doc/clip_path.rb.html (define_clip_path example)

### Imagemagick

* http://www.imagemagick.org/Usage/draw/
* http://www.imagemagick.org/Usage/anim_opt/
* http://www.imagemagick.org/Usage/transform/#fx
* http://www.imagemagick.org/Usage/layers/
* http://www.imagemagick.org/script/command-line-options.php#delete
* http://www.imagemagick.org/script/fx.php
* http://www.imagemagick.org/script/escape.php
* http://www.imagemagick.org/Usage/annotating/#watermarking
* http://www.imagemagick.org/Usage/anim_mods/#frame_mod

* http://www.ioncannon.net/linux/81/5-imagemagick-command-line-examples-part-1/

## Bash guides

* http://andreinc.net/2011/09/04/bash-scripting-best-practice/
* http://stackoverflow.com/questions/242538/unix-shell-script-find-out-which-directory-the-script-file-resides
