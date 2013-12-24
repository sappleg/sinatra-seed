module Ottoman
    module OttomanORM
        module Representation
            def to_hash
                pairs = {}
                attributes.each do |attribute|
                    pairs[attribute] = send(attribute) if self.has_attribute?(attribute)
                # NOTE: This may be extremely inefficient
                end
                pairs
            end

            def to_json_esq
                self.to_hash.to_json
            end
        end
    end
end
