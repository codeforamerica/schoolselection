source 'http://rubygems.org'

gem 'rails', '3.1.0.rc5'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'


# Gems used only for assets and not required
# in production environments by default.

gem 'jquery-rails'
gem 'paperclip'
gem "compass", ">= 0.11.5"

group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-rails', "~> 3.1.0.rc"
  gem 'uglifier'
end

group :production do 
  gem 'pg'
end

group :development do
  gem 'rails3-generators'
  gem "haml-rails"
  gem 'nokogiri'
  gem 'mechanize'
  gem 'mysql2', '~> 0.3.6'
end

group :test do
  gem "rspec"
  gem "rspec-rails"
  gem "factory_girl"
  gem 'turn', :require => false
end
