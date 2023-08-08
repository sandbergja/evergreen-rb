# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in evergreen-ils.gemspec
gemspec

gem 'rake'

group :test do
  gem 'rspec'
  gem 'webmock'
end

group :check do
  gem 'flay'
  gem 'flog'
  gem 'rbs'
  gem 'reek'
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rspec', require: false
  gem 'steep'
end

group :development do
  gem 'debug'
end
