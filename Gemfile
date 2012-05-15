source "http://rubygems.org"

gem "rake"

group :development do
  gem "activerecord", path: '/home/ejiao/projects/gems/rails/activerecord'
  gem "jeweler", "~> 1.8.0"
  gem "yard", "~> 0.8.1"
end

group :test do
  gem "database_cleaner", "~> 0.7.2"
  if RUBY_VERSION >= '1.9.0'
    gem "debugger", "~> 1.1.3"
    gem "simplecov", "~> 0.6.4"
  else
    gem 'ruby-debug'
    gem "rcov", "~> 1.0.0"
  end
  if RUBY_ENGINE == 'jruby'
    gem 'jdbc-sqlite3'
  else
    gem 'sqlite3'
  end
end