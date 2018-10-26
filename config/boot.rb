require 'rubygems/package'
require 'bundler/inline'

gemfile do
  source 'https://rubygems.org'
  gem 'rubyzip', '>= 1.0.0'
  gem 'rchardet'
  gem 'dry-monads'
end
