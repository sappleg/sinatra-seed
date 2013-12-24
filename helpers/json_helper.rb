module Ottoman
    module JsonHelper

        def to_json_a hash={}
            self.instance_variables.each do |var|
                hash[var.to_s[1..-1]] = self.instance_variable_get var
            end
            hash.to_json
        end

        def from_json! string
            JSON.load(string).each do |var, val|
                self.instance_variable_set var, val
            end
        end

    end
end
