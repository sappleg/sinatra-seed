module Ottoman
    module OttomanORM
        module Datastore

            @@client = nil
            @@config = nil

            def self.create name, data
                if data
                    self.execute_sproc(name + '_create', data).getvalue(0,0)
                else
                    self.execute_sproc(name + '_create').getvalue(0,0)
                end
            end

            def self.update name, data
                self.execute_sproc(name + '_update', data).getvalue(0,0)
            end

            # def fetch name, id
            def self.fetch name, data
                self.execute_sproc(name + '_get', data).getvalue(0,0)
            end

            # def self.fetch_by_field name, field, value
            def self.fetch_by_field name, field, value
                self.execute_sproc(name + '_get_by_' + field, value).getvalue(0,0)
            end

            def self.delete name, data
                self.execute_sproc(name + '_delete', data).getvalue(0,0)
            end

            # TODO: remove news specific reference here
            def self.fetch_all *args
                name ||= args[0]
                data ||= args[1]
                # TODO: come up with cleaner overload method for this and execute_sproc
                if args.length == 1
                    if name == 'news'
                        self.execute_sproc(name + '_get', '').getvalue(0,0)
                    else
                        self.execute_sproc(name + 's_get', '').getvalue(0,0)
                    end
                else
                    self.execute_sproc(name + 's_get', data).getvalue(0,0) if data
                end
            end

            def self.verify_user hash
                self.execute_sproc('verify_user', hash).getvalue(0,0)
            end

            def self.custom sproc_name, data
                self.execute_sproc(sproc_name, data).getvalue(0,0)
            end

        protected

            def self.connect
                @@config = OttomanORM.configuration

                @@client  = PG::Connection.new(
                    :host => @@config['host'],
                    :port => @@config['port'],
                    :dbname => @@config['dbname'],
                    :user => @@config['user'],
                    :password => @@config['password']
                )
            end

            class << self
                alias :reconnect! :connect
            end

            def self.disconnect
                @@client.close()
            end

            def self.execute_sproc(sproc, args)
                self.connect
                results = @@client.exec(build_query_string(sproc, args))
                self.disconnect
                results
            end

            def self.build_query_string(sproc, args = '')
                if args == ''
                    'select ' + sproc + '()'
                elsif args.is_a? Array
                    ret = 'select ' + sproc + '(\''
                    args.each do |arg|
                        if arg != args.last
                            ret += '\'' + arg + '\',\''
                        else
                            ret += '\''+ arg + '\')'
                        end
                    end
                    ret
                else
                    'select ' + sproc + '(\'' + args + '\')'
                end
            end
        end
    end
end
