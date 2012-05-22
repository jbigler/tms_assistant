source 'http://rubygems.org'

gem "rails", "~> 3.2.0"
gem "thin"
gem 'devise', '~> 2.1.0'
gem "state_machine"
gem "friendly_id", "~> 4.0.0"
gem "haml"
gem 'calendar_helper', :git => 'git://github.com/topfunky/calendar_helper.git'
gem 'acts_as_list'
gem 'kaminari'
gem "yard"
gem "bluecloth"
gem 'prawn'
gem 'rails-i18n'
gem 'foundation_rails_helper', :git => 'git://github.com/jbigler/foundation_rails_helper.git'
gem 'i18n-active_record',
    :git => 'git://github.com/svenfuchs/i18n-active_record.git',
    :branch => 'rails-3.2',
    :require => 'i18n/active_record'

group :assets do
  gem "haml-rails"
  gem 'sass-rails', "  ~> 3.2.3"
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', ">= 1.0.3"
  gem 'zurb-foundation'
  gem 'jquery-rails'
  gem 'client_side_validations'
end

group :production do
  gem 'pg'
end

group :development do
  gem 'pry-rails'
  gem "heroku"
  gem "taps"
  gem "annotate"
  gem "rails3-generators"
  gem "hpricot"
  gem "ruby_parser"
  gem 'rails-footnotes', '>= 3.7.5.rc4'
  gem 'rails_best_practices'
  gem 'ruby-graphviz'
end

group :development, :test do
  gem 'sqlite3'
  gem 'factory_girl_rails'
  gem "rspec-rails"
end

group :test do
  gem "autotest-standalone"
  gem "autotest-rails-pure"
  gem "autotest-notification"
  gem "launchy"
  gem "timecop"
  gem "shoulda-matchers"
end
