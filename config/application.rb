# application.rb

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Scheduling
  # application
  class Application < Rails::Application
    Figaro.load
    # -- all .rb files in that directory are automatically loaded.
  end
end
