source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

gem 'rails',        '~> 5.2.2'
gem 'pg',           '>= 0.18', '< 2.0'
gem 'puma',         '~> 3.12'
gem 'sass-rails',   '~> 5.0'
gem 'uglifier',     '>= 1.3.0'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks',   '~> 5'
gem 'jbuilder',     '~> 2.5'
gem 'bootsnap',     '>= 1.1.0', require: false

gem 'bootstrap',               '~> 4.1'
gem 'data-confirm-modal',      '~> 1.6.2'
gem 'jquery-rails',            '~> 4.3'
gem 'jquery-ui-rails',         '~> 6.0'

gem 'devise',                 '~> 4.7'
gem 'omniauth-memair',        '~> 0.0.5'

gem 'memair', '~> 0.1.3'

gem 'auto_strip_attributes', '~> 2.5'
gem 'geokit-rails',          '~> 2.3.1'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'pry'
end

group :development do
  gem 'web-console',           '>= 3.3.0'
  gem 'listen',                '>= 3.0.5', '< 3.2'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
