# frozen_string_literal: true

$LOAD_PATH.unshift(File.join(__dir__, 'lib'))

Gem::Specification.new do |gem|
  gem.name = 'call_me_ruby'
  gem.version = '1.2.0'
  gem.homepage = 'https://github.com/nathankleyn/call_me_ruby'
  gem.license = 'MIT'

  gem.authors = ['Nathan Kleyn']
  gem.email = ['nathan@nathankleyn.com']
  gem.summary = 'Simple, declarative, ActiveModel style callbacks (aka hooks or events) in Ruby!'
  gem.description = <<~DESC
    Simple, declarative, ActiveModel style callbacks (aka hooks or events) in
    Ruby! Once mixed-in, you can get awesome callback and hooks within any class
    you want!
  DESC

  gem.files = Dir['**/*'].select { |d| d =~ %r{^(README.md|lib/)} }

  gem.add_development_dependency 'coveralls', '~> 0.8.22'
  gem.add_development_dependency 'filewatcher', '~> 1.1', '>= 1.1.1'
  gem.add_development_dependency 'pry-byebug', '~> 3.6', '>= 3.6.0'
  gem.add_development_dependency 'rspec', '~> 3.8', '>= 3.8.0'
  gem.add_development_dependency 'rubocop', '~> 0.59.2'
  gem.add_development_dependency 'rubocop-rspec', '~> 1.29', '>= 1.29.1'
end
