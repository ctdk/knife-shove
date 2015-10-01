$:.unshift(File.dirname(__FILE__) + '/lib')
require 'knife-shove/version'

Gem::Specification.new do |s|
  s.name = "knife-shove"
  s.version = Knife::Shove::VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README.rdoc", "LICENSE"]
  s.summary = "Knife plugin for goiardi shovey"
  s.description = s.summary
  s.author = "John Keiser"
  s.email = "jkeiser@opscode.com"
  s.homepage = "https://github.com/ctdk/knife-shove"

  # We need a more recent version of mixlib-cli in order to support --no- options.
  # ... but, we can live with those options not working, if it means the plugin
  # can be included with apps that have restrictive Gemfile.locks.
  # s.add_dependency "mixlib-cli", ">= 1.2.2"

  s.add_dependency 'chef', '>= 11.10.4'
  s.require_path = 'lib'
  s.files = %w(LICENSE README.rdoc Rakefile) + Dir.glob("{lib,spec}/**/*")
end
