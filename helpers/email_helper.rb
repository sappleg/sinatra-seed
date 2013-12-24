require 'sinatra/base'
require 'faraday'

module Sinatra
    module EmailHelper
        def connect
            conn = Faraday.new(:url => 'https://api.mailgun.net/v2') do |faraday|
                faraday.request :url_encoded
                faraday.response :logger
                faraday.adapter Faraday.default_adapter
            end

            conn.basic_auth('api', settings.mailgun_secret_key)
            conn
        end

        def send_email params
            conn = connect
            # example params
            # params = {
            #     :from => 'REscour <info@mg.rescour.com>',
            #     :to => 'spencer.applegate3@gmail.com',
            #     :subject => 'Hello',
            #     :text => 'World'
            # }
            conn.post('spencerapplegate.com/messages', params)
        end
    end

    helpers EmailHelper
end
