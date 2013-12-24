require 'pg'
require 'yaml'
require 'json'

require_relative 'ottoman_orm/datastore'
require_relative 'ottoman_orm/error'
require_relative 'ottoman_orm/representation'
require_relative 'ottoman_orm/model'
require_relative 'ottoman_orm/core_ext'

module Ottoman
    module OttomanORM
        VERSION = "0.0.3"
        @@client = nil
        @@configuration = nil

        # def self.connect
        #     @@client = Datastore.new @@configuration
        # end

        def self.client
            @@client
        end

        def self.config parameters = {}
            @@configuration = YAML.load_file(File.join('config', 'ottoman_orm.yml'))[parameters[:mode]]
        end

        def self.configuration
            @@configuration
        end
    end
end
