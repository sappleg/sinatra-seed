module Ottoman
    class NonExistingUser < StandardError
        @@info = { :message => 'user not found', :status => 404 }

        def status
            @@info[:status]
        end

        def data
            @@info
        end
    end

    class NoVerifiedRole < StandardError
        @@info = { :message => 'cannot manually remove verified role', :status => 400 }

        def status
            @@info[:status]
        end

        def data
            @@info
        end
    end

    class NotEnoughAdmins < StandardError
        @@info = { :message => 'you are the only admin, you cannot remove that role until
                   you have someone to replace you', :status => 400 }

        def status
            @@info[:status]
        end

        def data
            @@info
        end
    end
end
