# frozen_string_literal: true

source "https://rubygems.org"

gemspec

gem "html-proofer", "~> 5.0", group: :test

# Provides `jekyll post` and other content scaffolding commands.
gem "jekyll-compose", group: :jekyll_plugins

# Explicit dependency to silence Ruby 3.5 logger warning.
gem "logger"

platforms :windows, :jruby do
  gem "tzinfo", ">= 1", "< 3"
  gem "tzinfo-data"
end

gem "wdm", "~> 0.2.0", :platforms => :windows
