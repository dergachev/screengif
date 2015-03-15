# Screengif

A commandline tool to convert SCREENCAST.mov into ANIMATED.gif

Here's what happens when you apply it to [demo.mov](https://raw.github.com/dergachev/screengif/master/demo.mov)

<img src="https://raw.github.com/dergachev/screengif/master/demo.gif" width="400" />

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
    -r, --framerate FPS              Specify amount of frames per second to keep. (default: 5)
    -w, --max-width PIXELS           Output image max width, in pixels.
        --max-height PIXELS          Output image max height, in pixels.
        --no-contrast                Skip increasing contrast using imagemagick.
    -f, --fuzz PERCENT               Imagemagick fuzz factor for color reduction. (default: 5%)
        --no-coalesce                Skip Magick::ImageList#coalesce() if input doesn't need it.
        --no-gifsicle                Prevent filter the output through gifsicle. Greatly increases output file size.
    -h, --help                       Show this message
    -v, --verbose                    Verbose output
        --version                    Show version
```

## Installation

### Under Docker

If you have docker running, this is the quickest way to get
started with screengif:

```
git clone git@github.com:dergachev/screengif.git
cd screengif

make build      # or alternatively, 'docker pull dergachev/screengif'

make docker-convert args="-i demo.mov -o demo-docker.gif"

# input files must be relative to cloned screengif repo
cp /path/to/myMovie.mov .

make docker-convert args="-i myMovie.mov -o myMovie.gif"
```

See Dockerfile and Makefile for how it works.

### With Vagrant

If you have Vagrant and Virtualbox already installed, this is both faster and cleaner than downloading and compiling all the dependencies in OS X. To install, simply do the following:

```
vagrant up
```

The easiest way to use it is to copy your image to screengif project directory (shared in the VM under /vagrant), and run the following:

```
cp ~/screencast.mov ./screencast.mov
vagrant ssh -- '/vagrant/screengif.rb --input /vagrant/screencast.mov --output /vagrant/output/screencast.gif'
ls ./output/screencast.gif # should exist!

# when finished, destroy the VM
vagrant destroy -f
```

### On OSX, with homebrew

The following works with OS X and homebrew, assuming you have ruby 1.9.2+:

You may need to install brew-cask: https://github.com/phinze/homebrew-cask

```bash
git clone https://github.com/dergachev/screengif.git
cd screengif

# x-quartz is a dependency for gifsicle, no longer installed starting on 10.8
brew cask install xquartz 
open /opt/homebrew-cask/Caskroom/xquartz/2.7.7/XQuartz.pkg # runs the XQuartz installer

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

See [DEVNOTES](https://github.com/dergachev/screengif/blob/master/DEVNOTES.md)
