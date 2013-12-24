require_relative 'route'

module Ottoman
    class AuthRoutes < Route

        # user login
        Route.post '/auth/login/' do
            if user_id = authenticate(get_data)
                set_cookie user_id, request.ip
                settings.valid_login.to_json
            else
                settings.invalid_login.to_json
            end
        end

        # user logout
        Route.post '/auth/logout/' do
            clear_cookie
        end

        # user challenge to verify information
        Route.get '/auth/users/:auth_hash' do
            User.verify params[:auth_hash]
        end

        # user deletion
        Route.delete '/auth/user/:id/cancel/', :auth => ['admin', 'staff'] do
            # NOTE: need to allow client admins to delete users on their subscriptions
            # TODO: think of best strategy for this. May involve billing information deletions too
            ap 'cancel this ho'
        end

        Route.post '/admin/reset_password/', :auth => ['admin', 'staff'] do
            User.hard_password_reset({:user_id => get_data[:user_id],
                :new_password => Sinatra::Authentication::Password::Hashing.encrypt(JSON.parse(get_data[:password], :symbolize_names => true))}.to_json)
        end

        Route.post '/auth/payment/', :auth => [] do
            # TODO: do not allow staff users to put in tokens for themselves
            if Client.fetch_by_field('user_id', settings.id).stripe_token
                { :message => 'you cannot overwrite the token' }.to_json
            else
                # TODO: verifiy token is who's it says it is
                User.set_stripe_token(settings.id, get_data[:token])
            end
        end

        Route.put '/auth/payment/', :auth => ['admin'] do
            # TODO: do not allow staff users to put in tokens for themselves
            # TODO: verifiy token is who's it says it is
            User.set_stripe_token(settings.id, get_data[:token])
        end
    end
end
