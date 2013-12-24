require_relative 'model'

module Ottoman
    class User < Model
        include Sinatra::Authentication::User
        include Ottoman::JsonHelper

        attribute :id, :client_id, :email, :first_name, :last_name
        attribute :password, :phone, :verification_hash, :hash, :salt

        def initialize body=nil
            super body
            # TODO: come up with a better solution than the id check
            @password = Sinatra::Authentication::Password::Hashing.encrypt(@password) unless @id
        end

        def self.get_class_name
            self.name.downcase.split(/::/).last
        end

        def self.fetch_all
            users = []
            data = OttomanORM::Datastore.fetch_all(get_class_name)
            JSON.parse(data, :symbolize_names => true).each do |user|
                users << new(user)
            end if data
            return users
        end

        def self.find_by_login email
            self.fetch_by_field('email', email)
        end

        def self.verify hash
            OttomanORM::Datastore.verify_user(hash)
        end

        def self.fetch_by_token token
            self.fetch_by_field('token', token)
        end

        def self.hard_password_reset data
            OttomanORM::Datastore.custom('reset_password', data)
        end

        def self.set_stripe_token id, token
            OttomanORM::Datastore.custom('set_stripe_token', { :id => id, :token => token }.to_json)
        end

        # TODO: clean this up and move it to a module
        def self.construct_json mdus
            ret = []
            mdus.each do |mdu|
                hash = {}
                mdu.instance_variables.each do |var|
                    if @@object_attributes.include? var.to_s[1..-1].to_sym
                        sub_objs = []
                        mdu.instance_variable_get(var).each do |blah|
                            sub_objs <<  blah._to_json
                        end
                        hash[var.to_s[1..-1]] = sub_objs
                    elsif @@object_attribute.include? var.to_s[1..-1].to_sym
                        hash[var.to_s[1..-1]] = mdu.instance_variable_get(var)._to_json
                    else
                        hash[var.to_s[1..-1]] = mdu.instance_variable_get var
                    end
                end
                ret << hash
            end
            ret.to_json
        end

        def create_token
            OttomanORM::Datastore.create('token', @id)
        end

        def verify_password hash
            puts hash
        end

        def reset_password password, token=nil
            @password = Sinatra::Authentication::Password::Hashing.encrypt(password)
            if message = self.save
                # remove token from db
                OttomanORM::Datastore.custom('delete_password_reset_token', { :token => token }.to_json) if token
                return message
            else
                # TODO: raise unsuccessful save
            end

        end

        def check_password? password
            Sinatra::Authentication::Password::Hashin.check?(password, @password)
        end

        def update_roles roles
            number_admins = OttomanORM::Datastore.custom('count_admins', { :client_id => @client_id }.to_json).to_i
            if roles.include? 'admin'
                # NOTE: possible duplicate entry error
                add_admin
            else
                raise NotEnoughAdmins unless number_admins > 1
                remove_admin
            end
        end

        def remove_admin
            OttomanORM::Datastore.delete('user_role', { :user_id => @id, :role => 'admin' }.to_json)
        end

        def add_admin
            # NOTE: possible duplicate entry error
            OttomanORM::Datastore.create('user_role', { :user_id => @id, :role => 'admin' }.to_json)
        end

        def belongs_to_client? admin_id
            belongs = OttomanORM::Datastore.custom('user_belongs_to_client', { :admin_id => admin_id, :user_id => self.id }.to_json)
            if belongs == 't'
                return true
            else
                return false
            end
        end

        def _to_json hash={}
            self.instance_variables.each do |var|
                hash[var.to_s[1..-1]] = self.instance_variable_get var
            end
            hash
        end

        # NOTE: Implemented by contract from sinatra-authentication
        def self.user_auth cookies=nil, required_roles=[]
            if cookies[:ottoman] && auth_data = Ottoman::OttomanORM::Datastore.fetch('cookie', { :hash => cookies[:ottoman] }.to_json)
                # NOTE: users must ALWAYS be verified to do any work in this application, including staff
                required_roles << 'verified' if !required_roles.include? 'verified'

                # TODO: move this logic into Ottoman and call from here
                auth_data = JSON.parse(auth_data, :symbolize_names => true)
                id = auth_data[:user_id]
                roles = []

                return id if required_roles == []

                auth_data[:user_roles].each do |role|
                    roles << role[:name]
                end if auth_data[:user_roles]

                auth_data[:client_roles].each do |role|
                    roles << role[:name]
                end if auth_data[:client_roles]

                return id if (required_roles & roles) == required_roles
            end
        end
    end
end
