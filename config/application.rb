require_relative 'boot'

require 'rails/all'
require 'prawn'
require 'barby'
require 'barby/barcode/code_39'
# require 'barby/outputter/pdfwriter_outputter'
require 'barby/outputter/prawn_outputter'
# require 'barby/outputter/png_outputter'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module PalletTracker
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
