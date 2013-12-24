require 'rack/test'

ENV['RACK_ENV'] = 'test'

require 'bundler'
Bundler.require :default, :test

require_relative '../app.rb'

require_relative 'support/unit_helpers'
require_relative 'support/acceptance_helpers'

module RSpecMixin
    include UnitHelpers
    include AcceptanceHelpers
    include Rack::Test::Methods
    def app() Ottoman::Application end
end

RSpec.configure { |c| c.include RSpecMixin }
