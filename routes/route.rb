module Ottoman
    class Route < Sinatra::Base
        register Sinatra::Authentication
        helpers Sinatra::Authentication::Helpers
        helpers Sinatra::Cookies
        helpers Sinatra::EmailHelper

        set :private_key, 'Thousands000'
        set :valid_login, { :message => 'successful login', :status => 200 }
        set :invalid_login, { :message => 'invalid email and password combination', :status => 401 }
        set :valid_logout, { :message => 'successful logout', :status => 200 }
        set :authentication_failure, { :message => 'authentication failed', :status => 401 }
        set :login_user_class, lambda { Ottoman::User }
        set :cookie_options, { :expires => (Time.now + 3600*24),
                               :path => '/',
                               :domain => nil,
                               :httponly => true,
                               :secure => nil }
        set :ignored_by_return_to, /(jpe?g|png|gif|css|js)$/
        set :stripe_publishable_key, 'pk_test_9ODlk9EAKJlJ1gc86Gu17ApT'
        set :stripe_secret_key, 'sk_test_VvmQ51BI2s9AuwMCf63QMiNi'
        set :mailgun_secret_key, 'key-4g21ey3jxwx4ue4sjgekdnzcwe1u2q15'
        set :id, nil
        set :auth_group, nil
        set(:auth) do |*roles|
            condition do
                if ENV['RACK_ENV'] == 'test'
                    settings.id = '3701b231-9848-4f0d-82ad-0cf8f0a0133e'
                    settings.auth_group = ENV['OTTOMAN_AUTH_GROUP'].to_i if ENV['OTTOMAN_AUTH_GROUP']
                    return true
                end

                if roles[0].is_a? Array
                    roles.each_with_index do |role_set, index|
                        if settings.id = require_auth(cookies, role_set)
                            settings.auth_group = index
                            return true
                        end
                    end
                else
                    if settings.id = require_auth(cookies, roles)
                        settings.auth_group = 0
                        return true
                    elsif roles[roles.length - 1] == 'pass'
                        settings.auth_group = -1
                        return true
                    end
                end

                error 401
                return false
            end
        end

        post '/test/' do
            # params = {
            #     :from => 'REscour <me@spencerapplegate.com>',
            #     :to => 'spencer.applegate3@gmail.com',
            #     :subject => 'Hello',
            #     :text => 'World'
            # }
            # send_email params

            # begin
            #     OttomanORM::Datastore.create('penis', {}.to_json)
            # rescue => e
            #     error 500, OttomanError
            # end
        end

        def set_cookie user_id, ip
            auth_hash = Sinatra::Authentication::Cookies::Hashing.encrypt(user_id, ip, settings.private_key)
            OttomanORM::Datastore.create('cookie', { :user_id => user_id,
                                                     :hash => auth_hash[:hash],
                                                     :salt => auth_hash[:salt]
                                                   }.to_json )
            # perform on successful save of hash and salt
            cookies[:ottoman] = auth_hash[:hash]
        end

        def clear_cookie
            if cookies[:ottoman]
                cookies.delete(:ottoman) if cookies[:ottoman]
                settings.valid_logout.to_json
            else
                settings.invalid_login.to_json
            end
        end

        # NOTE: check to see if this is depricated
        def get_id_from_cookie
            Sinatra::Authentication::Cookies::Hashing.decrypt(cookies[:ottoman_connection], settings.private_key)
        end

        def get_data
            JSON.parse(request.body.read, :symbolize_names => true)
        end

        def create_billing_record data
            OttomanORM::Datastore.custom('billing_history_create', data)
        end
    end
end
