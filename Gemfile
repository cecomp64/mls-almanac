source 'https://rubygems.org'
ruby "2.1.2"

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

group :production do
  gem 'pg', '0.15.1'
  gem 'mysql'
end

# Use sqlite3 as the database for Active Record
group :development do
  gem 'sqlite3'
end

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
gem 'byebug', group: [:development, :test]

# SportDB Gems
gem 'sportdb_cecomp64', :github => 'cecomp64/sport.db.ruby', :branch => 'master'
gem 'sportdb-admin'
gem 'sinatra', require: 'sinatra/base'

gem 'worlddb-flags', '0.1.0'  # use bundled country flags
gem 'sportdb-logos',    '0.1.0',  git: 'https://github.com/sportlogos/sport.db.logos.ruby.git', branch: 'gh-pages'
gem 'footballdb-logos', '0.1.0',  git: 'https://github.com/sportlogos/football.db.logos.ruby.git', branch: 'gh-pages'

# Football Data Gems
gem 'worlddb-data', '9.9.9', git: 'https://github.com/openmundi/world.db.git'
gem 'major-league-soccer-data', '9.9.9', git: 'https://github.com/openfootball/major-league-soccer.git'

# Pagination
gem 'kaminari'
