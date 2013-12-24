require_relative 'route'

module Ottoman
    class UserRoutes < Route

        Route.get '/users/', :auth => ['admin'] do
            # TODO: only allow admins to get users from their client
            begin
                users = User.fetch_all()
                User.construct_json(users)
            rescue => e
                error e.status, e
            end
        end

        Route.put '/users/', :auth => ['admin'] do
            begin
                raise NonExistingUser unless user = User.fetch(settings.id)
                user.update_attributes get_data
            rescue => e
                error e.status, e
            end
        end

        Route.put '/users/:id', :auth => ['admin'] do
            # TODO: only allow admins to change their client's users info
            begin
                raise NonExistingUser unless user = User.fetch(params[:id])
                user.update_attributes(get_data) if user.belongs_to_client?(settings.id)
            rescue => e
                error e.status, e
            end
        end

        Route.put '/users/:id/roles/', :auth => ['admin'] do
            # TODO: only allow admins to change their client's users info
            # TODO: cannot remove all admins
            roles = get_data[:roles]
            begin
                raise NoVerifiedRole unless roles.include?('verified')
                raise NonExistingUser unless user = User.fetch(params[:id])
                user.update_roles(roles) if user.belongs_to_client?(settings.id)
            rescue => e
                ap e
                error e.status, e
            end
        end

        # user signup
        Route.post '/users/', :auth => ['admin', 'pass'] do
            begin
                # TODO: handle duplicate email
                if settings.auth_group == 0
                    raise NonExistingUser unless user = User.fetch(settings.id)
                    mod_data = get_data
                    mod_data[:client_id] = user.client_id
                    # create user with same client_id
                    { :id => User.create(mod_data).id }.to_json
                    # send user an email with the auth token
                elsif settings.auth_group == -1
                    # create user without a client
                    { :id => User.create(get_data).id }.to_json
                    # send user an email with the auth token
                end
            rescue => e
                ap e
            end
        end

        Route.delete '/users/:id', :auth => ['staff', 'admin'] do
            begin
                raise NonExistingUser unless user = User.fetch(params[:id])
                if settings.auth_group == 0
                    user.delete
                elsif settings.auth_group == 1
                    user.delete if user.belongs_to_client?(settings.id)
                end
            rescue => e
                ap e
                error e.status, e
            end
        end

        # reset password
        Route.post '/user/password/reset/', :auth => ['admin'] do
            # TODO: create way for staff users to reset passwords of anyone
            begin
                # TODO: admin can reset clients users passwords and his own
                body = get_data
                if body[:email]
                    # TODO: send email to this address with reset
                    token = User.find_by_login(body[:email]).create_token
                    return token
                else
                    # TODO: match token then reset the user's password
                    raise NonExistingUser unless user = User.fetch_by_token(body[:token])
                    user.reset_password(body[:newPassword], body[:token])
                end
            rescue => e
                error e.status, e
            end
        end

        # change your own password
        Route.put '/user/password/', :auth => ['admin'] do
            begin
                raise NonExistingUser unless user = User.fetch(settings.id)
                if user.check_password? get_data[:oldPassword]
                    user.reset_password get_data[:newPassword]
                else
                    # TODO: raise incorrect password error
                end
            rescue => e
                error e.status, e
            end
        end

        Route.put '/users/:id/password/', :auth => ['admin'] do
            # TODO: create way for staff users to reset passwords of anyone
            begin
                raise NonExistingUser unless user = User.fetch(params[:id])
                user.reset_password(get_data[:newPassword]) if user.belongs_to_client?(settings.id)
            rescue => e
                error e.status, e
            end
        end

        Route.get '/users/verify/' do
            token = get_data[:token]
            ap token
        end
    end
end
