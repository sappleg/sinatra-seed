$: << '.'

require 'sinatra/base'
require 'sinatra/cookies'
require 'sinatra/authentication'
require 'sinatra/cross_origin'
require 'stripe'

# Environment specific, move eventually
require 'awesome_print'

require_relative 'helpers/init'
require_relative 'errors/init'
require_relative 'routes/init'
require_relative 'models/init'

module Ottoman
    class Application < Sinatra::Base

        configure do
            set :app_file, __FILE__
            set :allow_origin, :any

            disable :static
        end

        configure :development do
            enable :logging, :dump_errors
            disable :raise_errors, :show_exceptions
            OttomanORM.config(:mode => 'development')
        end

        configure :test do
            enable :logging, :dump_errors, :raise_errors
            OttomanORM.config(:mode => 'test')
        end

        configure :production do
            enable :cross_origin
            disable :raise_errors, :show_exceptions
            OttomanORM.config(:mode => 'production')
        end

        use Route
    end
end
