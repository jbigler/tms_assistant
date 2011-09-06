source 'http://rubygems.org'

gem "rails", "~> 3.1"
gem "thin"
gem "devise", ">= 1.4.4"
gem "state_machine"
gem "friendly_id", "~> 3.1"
gem "haml"
gem 'calendar_helper'
gem 'acts_as_list', :git => 'git://github.com/swanandp/acts_as_list.git'
gem 'kaminari'
gem "yard"
gem "bluecloth"
gem 'prawn'

group :assets do
  gem "haml-rails"
  gem 'sass-rails', "  ~> 3.1"
  gem 'coffee-rails', "~> 3.1"
  gem 'uglifier'
end

gem 'jquery-rails'
gem 'client_side_validations'

group :production do
  gem 'pg'
end

group :development do
  gem 'pry'
  gem "heroku"
  gem "taps"
  gem "annotate"
  gem "rails3-generators"
  gem "hpricot"
  gem "ruby_parser"
end

group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails'
  gem "rspec-rails"
end

group :test do
  gem "autotest-standalone"
  gem "autotest-rails-pure"
  gem "launchy"
  gem "timecop"
  gem "shoulda-matchers"
end
