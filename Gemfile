source "https://rubygems.org"

gemspec

# git "https://github.com/refinery/refinerycms", branch: "master" do
#   gem 'refinerycms'
#
#   group :development, :test do
#     gem 'refinerycms-testing'
#
#   end
# end

gem 'refinerycms', path: '/Applications/MAMP/www/refinerycms'
gem 'dragonfly'

group :development, :test do
  gem 'refinerycms-testing', path: '/Applications/MAMP/www/refinerycms'
  gem 'rack-cache', :require => 'rack/cache'
end

group :test do
  gem 'pry'
  gem 'launchy'
  gem 'selenium-webdriver', '~> 2.43'
  gem 'awesome_print'
end

# Database Configuration
unless ENV['TRAVIS']
  gem 'activerecord-jdbcsqlite3-adapter', :platform => :jruby
  gem 'sqlite3', :platform => :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'mysql'
  gem 'activerecord-jdbcmysql-adapter', :platform => :jruby
  gem 'jdbc-mysql', '= 5.1.13', :platform => :jruby
  gem 'mysql2', :platform => :ruby
end

if !ENV['TRAVIS'] || ENV['DB'] == 'postgresql'
  gem 'activerecord-jdbcpostgresql-adapter', :platform => :jruby
  gem 'pg', :platform => :ruby
end

# Refinery/rails should pull in the proper versions of these
group :assets do
  gem 'sass-rails'
  gem 'coffee-rails'
end

# Load local gems according to Refinery developer preference.
if File.exist? local_gemfile = File.expand_path('../.gemfile', __FILE__)
  eval File.read(local_gemfile)
end
