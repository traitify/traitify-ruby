source "https://rubygems.org"

# Specify your gem's dependencies in traitify.gemspec
gemspec

group :development do
  gem "rubocop-airbnb",
    git: "https://github.com/mcamara/ruby.git",
    glob: "rubocop-airbnb/*.gemspec" # Until airbnb supports ruby 2.6
  gem "rubocop-traitify", git: "https://github.com/traitify/rubocop-traitify.git"
end
