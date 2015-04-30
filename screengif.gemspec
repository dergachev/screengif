$:.unshift File.expand_path('../lib', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "screengif"
  spec.version       = "0.0.2"
  spec.authors       = "Alex Dergachev"
  spec.email         = "alex@evolvingweb.ca"
  spec.summary       = 'Script to convert mov files to animated gifs.'
  spec.description   = 'Wrapper on ffmpeg and imagemagick to convert .mov to .gif'
  spec.homepage      = 'https://github.com/dergachev/screengif'
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/) - ["demo.gif", "demo.mov"]
  spec.bindir        = 'bin'
  spec.executables   = 'screengif'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_path  = 'lib'

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
end
