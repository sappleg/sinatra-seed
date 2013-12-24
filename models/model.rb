module Ottoman
    class Model < Ottoman::OttomanORM::Model

        # NOTE: Parent class should not know anything about child class. Change this somehow
        def self.get_class_name
            self.name.downcase.split(/::/).last
        end

        def get_class_name
            self.class.name.downcase.split(/::/).last
        end

        def to_hash
            Hash[instance_variables.map { |name| [name[1..-1].to_sym, instance_variable_get(name)] } ]
        end
    end
end
