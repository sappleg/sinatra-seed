require_relative 'model'

module Ottoman
    class Comment < Model
        include Ottoman::JsonHelper

        attribute :id, :user_id, :text

        # TODO: include email in data
        def self.fetch_all_from_mdu user_id, mdu_id
            comments = []
            JSON.parse(OttomanORM::Datastore.custom('mdu_comments_get', { :user_id => user_id, :mdu_id => mdu_id }.to_json), :symbolize_names => true).each do |comment|
                comments << new(comment)
            end
            return comments
        end

        def self.create_for_mdu user_id, mdu_id, data
            OttomanORM::Datastore.custom('mdu_comment_create', { :user_id => user_id, :mdu_id => mdu_id, :comment_data => data }.to_json)
        end

        def self.fetch user_id, mdu_id, comment_id
            if result = OttomanORM::Datastore.custom('mdu_comment_get', { :user_id => user_id, :mdu_id => mdu_id, :comment_id => comment_id }.to_json)
                new JSON.parse(result , :symbolize_names => true)
            end
        end

        def self.construct_json comments
            ret = []
            comments.each do |comment|
                hash = {}
                comment.instance_variables.each do |var|
                    if @@object_attributes.include? var.to_s[1..-1].to_sym
                        sub_objs = []
                        comment.instance_variable_get(var).each do |blah|
                            sub_objs <<  blah._to_json
                        end
                        hash[var.to_s[1..-1]] = sub_objs
                    elsif @@object_attribute.include? var.to_s[1..-1].to_sym
                        hash[var.to_s[1..-1]] = comment.instance_variable_get(var)._to_json
                    else
                        hash[var.to_s[1..-1]] = comment.instance_variable_get var
                    end
                end
                ret << hash
            end
            ret.to_json
        end

        def construct_json
            hash = {}
            self.instance_variables.each do |var|
                if @@object_attributes.include? var.to_s[1..-1].to_sym
                    sub_objs = []
                    self.instance_variable_get(var).each do |blah|
                        sub_objs <<  blah._to_json
                    end
                    hash[var.to_s[1..-1]] = sub_objs
                elsif @@object_attribute.include? var.to_s[1..-1].to_sym
                    hash[var.to_s[1..-1]] = self.instance_variable_get(var)._to_json
                else
                    hash[var.to_s[1..-1]] = self.instance_variable_get var
                end
            end
            hash.to_json
        end

        def _to_json hash={}
            self.instance_variables.each do |var|
                hash[var.to_s[1..-1]] = self.instance_variable_get var
            end
            hash
        end
    end
end
