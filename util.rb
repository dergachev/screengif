#!/usr/bin/env ruby 


module Screengif
  class StatusPrinter
    # inspired by http://stackoverflow.com/a/6679572/9621
    def initialize(stream)
      @previous_size = 0
      @stream = stream || $stdout
    end

    def printText(text)
      if @previous_size > 0
        @stream.print "\033[#{@previous_size}D"
        @stream.print(" " * @previous_size) 
        @stream.print "\033[#{@previous_size}D"
      end
      @stream.print text
      @stream.flush
      @previous_size = text.gsub(/\e\[\d+m/,"").size
    end

    def done()
      @previous_size = 0
      @stream.print "\n"
    end
  end

  class ConversionStats
    def self.print(input_file, output_file, input, output)
      $stderr.puts "Conversion completed in #{Time.now - $startTime} seconds."
      if input_file # ffmpeg
        #   Duration: 00:00:04.28, start: 0.010333, bitrate: 11225 kb/s
        duration = (`ffmpeg -i '#{input_file}' 2>&1 | grep Duration`).gsub(/^.*Duration:\s*([^,]+),.*$/, '\1').gsub("\n",'')

        input_filesize = `ls -lh '#{input_file}' | awk '{print $5}'`.gsub("\n",'')
        $stderr.puts "Input: #{input_file} (#{duration}, #{input_filesize})"
      else # piped input
        input_contentsize = (input.bytesize.to_f / 2**10).to_i().to_s + "K"
        $stderr.puts "Input: STDIN (#{input_contentsize})"
      end
      if output_file
        output_filesize = `ls -lh '#{output_file}' | awk '{print $5}'`.gsub("\n",'')
        $stderr.puts "Output: '#{output_file}' (#{output_filesize})"
      else # piped output
        output_contentsize = (output.bytesize.to_f / 2**10).to_i().to_s + "K"
        $stderr.puts "Output: STDOUT (#{output_contentsize})"
      end
    end
  end
end
