module Ottoman
    module OttomanORM
        class Model
            # representation methods
            include OttomanORM::Representation

            # attributes list
            @@_attributes = []

            # object attributes list
            @@object_attribute = []
            @@object_attributes = []

            # attributes
            def self.attribute *names
                names.each { |name| @@_attributes << name }
                # names.each { |name| @_attributes << name }
                class_eval { attr_accessor *names }
            end
            class << self; alias :attributes :attribute; end

            # object attributes
            def self.object_attributes *names
                names.each { |name| @@object_attributes << name }
                # names.each { |name| @object_attributes << name }
                class_eval { attr_accessor *names }
            end

            def self.object_attribute *names
                names.each { |name| @@object_attribute << name }
                # names.each { |name| @object_attribute << name }
                class_eval { attr_accessor *names }
            end

            # object creation
            def self.create data
                self.new(data).save
            end

            def self.fetch data
                new JSON.parse(Ottoman::OttomanORM::Datastore.fetch(self.get_class_name, data), :symbolize_names => true)
            end

            def self.fetch_by_field field, value
                # Ottoman::User.new(JSON.parse(Ottoman::OttomanORM::Datastore.fetch_by_field(get_class_name, field, value), :symbolize_names => true))
                new JSON.parse(Ottoman::OttomanORM::Datastore.fetch_by_field(self.get_class_name, field, value), :symbolize_names => true)
            end

            # delete record
            def self.delete id
                message = Ottoman::OttomanORM::Datastore.delete(self.get_class_name, { :id => id }.to_json)
                freeze
                return message
            end


            # Initializes a new model with the given +params+.
            #
            #   class Person
            #       include OttomanORM::Model
            #       attr_accessor :name, :age
            #   end
            #
            #   person = Person.new(name: 'bob', age: '18')
            #   person.name # => "bob"
            #   person.age  # => 18
            #
            def initialize(params={})
                params.each do |attribute, value|
                    if @@object_attributes.include? attribute
                        objs = []
                        value.each do |sub_val|
                            objs << Ottoman.const_get(self.get_object_name(attribute)).new(sub_val)
                        end if value
                        self.public_send("#{attribute}=", objs)
                    elsif @@object_attribute.include? attribute
                        self.public_send("#{attribute}=", Object::const_get(self.get_object_name(attribute)).new(value)) if value
                    else
                        self.public_send("#{attribute}=", value)
                    end
                end if params

                super()
            end

            def attributes
                @@_attributes
            end

            # Indicates if the model is persisted. Default is +false+.
            #
            #   class Person
            #       include OttomanORM::Model
            #       attr_accessor :id, :name
            #   end
            #
            #   person = Person.new(id: 1, name: 'bob')
            #   person.persisted? # => false
            def persisted?
                !new_record?
            end

            def new_record?
                @id.blank?
            end

            def id
                @id
            end

            # validations
            # TODO: write actual validations
            def run_validations
                true
            end

            # save record
            def save
                return false unless run_validations
                create_or_update
            end

            def create_or_update
                new_record? ? create_record : update_record
            end

            def create_record
                result = JSON.parse(Ottoman::OttomanORM::Datastore.create(get_class_name, self.to_json_esq), :symbolize_names => true)
                @id = result[:id]
                # TODO: clean this up
                @verification_hash = result[:hash] if self.get_class_name == "user"
                self
            end

            def update_record
                Ottoman::OttomanORM::Datastore.update(get_class_name, self.to_json_esq)
            end

            # update record
            # def update_attribute attribute, value
            #     public_send("#{attribute}=", value)
            #     save
            # end

            def update_attributes attributes
                return if attributes.blank?
                attributes.stringify_keys.each_pair do |attribute, value|
                    public_send("#{attribute}=", value)
                end
                save
            end

            def delete
                message = Ottoman::OttomanORM::Datastore.delete(get_class_name, { :id => @id }.to_json) unless new_record?
                freeze
                return message
            end

            # TODO: abstract this into another module and take out specifc class names
            def get_object_name attr_name
                return attr_name.capitalize if @@object_attribute.include?(attr_name)
                # return attr_name.capitalize if @object_attribute.include?(attr_name)
                attr_name = attr_name.to_s
                if attr_name.include? '_'
                    if attr_name[-2, 2] == 'es' and attr_name != 'tour_dates'
                        attr_name.split('_')[0].capitalize + attr_name.split('_')[1][0...-2].capitalize
                    else
                        attr_name.split('_')[0].capitalize + attr_name.split('_')[1][0...-1].capitalize
                    end
                elsif attr_name == 'addresses'
                    attr_name[0...-2].capitalize
                else
                    attr_name[0...-1].capitalize
                end
            end

            def has_attribute?(attr_name)
                attr_name = '@' + attr_name.to_s
                self.instance_variables.include?(attr_name.to_sym)
            end
        end
    end
end
