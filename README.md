# Screengif

A commandline tool to convert SCREENCAST.mov into ANIMATED.gif

Here's what happens when you apply it to [demo.mov](https://raw.github.com/dergachev/screengif/master/demo.mov)

![](https://raw.github.com/dergachev/screengif/master/demo.gif)

## Usage

```
screengif.rb - Convert your screencast into a gif.
Usage:
	screengif.rb [options] [--input FILENAME.mov] [--output OUTPUTFILE.gif]
Examples:
	./screengif.rb --input demo.mov --output out.gif
	cat somefile.gif | ./screengif.rb --progressbar --framerate 10 --delay 50 --delay-last 5 > out.gif

Specific options:
    -i, --input FILENAME.mov         Use ffmpeg to convert FILENAME.mov into PPM image stream and process results.
                                     If missing, will process PPM or GIF image stream from STDIN.
    -o, --output FILENAME.gif        Output resulting GIF data to FILENAME.gif. (defaults to STDOUT).
    -p, --progressbar                Overlay progress bar on the animation.
    -d, --delay MS                   Animation frame delay, in tens of ms. (default: 10)
        --delay-last MS              Animation frame delay of last frame, in tens of ms. (default: 50)
    -r, --framerate FPS              Specify amount of frames per second to keep. (default: 10)
        --max-width PIXELS           Output image max width, in pixels. (default: 600)
        --max-height PIXELS          Output image max width, in pixels. (default: 600)
        --no-coalesce                Skip Magick::ImageList#coalesce() if input doesn't need it.
        --no-gifsicle                Prevent filter the output through gifsicle. Greatly increases output file size.
    -h, --help                       Show this message
    -v, --verbose                    Verbose output
        --version                    Show version
```

## Installation

## With Vagrant

If you have Vagrant and Virtualbox already installed, this is both faster and cleaner than downloading and compiling all the dependencies in OS X. To install, simply do the following:

```
vagrant up
```

The easiest way to use it is to copy your image to screengif project directory (shared in the VM under /vagrant), and run the following:

```
cp ~/screencast.mov ./screencast.mov
vagrant ssh -- '/vagrant/screengif.rb --input /vagrant/screencast.mov --output /vagrant/output/screencast.gif'
ls ./output/screencast.mov # should exist!

# when finished, destroy the VM
vagrant destroy -f
```

## Without Vagrant

The following works with OS X and homebrew, assuming you have ruby 1.9.2+:

You may need to install brew-cask: https://github.com/phinze/homebrew-cask

```bash
git clone https://github.com/dergachev/screengif.git
cd screengif

# xquartz is a dependency for gifsicle, no longer installed starting on 10.8
brew cask install xquartz 
open /usr/local/Cellar/x-quartz/2.7.4/XQuartz.pkg # runs the XQuartz installer

brew install ffmpeg imagemagick gifsicle
gem install rmagick
```

## Tips

See https://gist.github.com/dergachev/4627207#os-x-screencast-to-animated-gif
for a guide on how to use Quicktime Player to record a screencast on OS X.  
Keep in mind that other tools (like Screenflow) produce better video quality.

If you install [dropbox-screenshots](https://github.com/dergachev/dropbox-screenshots),
the following will automatically upload your new gif to Dropbox: 

    cp out.gif ~/Dropbox/Public/screenshots

## Resources

### Related solutions

* http://freezeframe.chrisantonellis.com/ (js library to freeze/play gifs)
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

## Ruby guides

* TODO: implement tests; see https://github.com/pgericson/progress_bar/blob/master/test/arguments_test.rb
* TODO: look at mixlib-{shellout,cli,logger}; https://github.com/opscode/mixlib-shellout
* TODO: look at https://github.com/bitboxer/simple_progressbar/blob/master/lib/simple_progressbar.rb
