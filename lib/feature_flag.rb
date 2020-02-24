require 'set'
require 'crc'

class FeatureFlag

    def initialize
        @active_features = Set.new
        @percentage_features = {} # feature_name: percentage (e.g., 0.5)
    end

    def activate_feature_percentage(feature_name, percentage) 
        @percentage_features[feature_name] = percentage
    end

    def activate_feature(feature_name) 
        @active_features.add(feature_name)
    end

    def deactivate_feature(feature_name)
        @active_features.delete(feature_name)
    end

    def is_feature_active(feature_name, id_object)
        feature_is_globally_active = @active_features.include?(feature_name)

        if feature_is_globally_active
            return true
        end

        if is_feature_active_for_percentage(feature_name, id_object)
            return true
        end

        return false
    end

    private

    def is_feature_active_for_percentage(feature_name, id_object)
        if id_object.respond_to? :id
            id = id_object.id
        else
            id = id_object[:id]
        end

        if id == nil
            puts "Object passed for is_feature_active_for_percentage does not have an id"
            puts "Object: #{id_object}"

            return false
        end

        percentage = @percentage_features[feature_name]

        if percentage != nil 
            crc = CRC.crc32.new # no idea if I'm using the correctly
            crc.update id.to_s

            # Lifted from https://github.com/FetLife/rollout
            puts crc.crc
            puts (2**32 - 1) / 100.0 * percentage
            return (crc.crc < (2**32 - 1) / 100.0 * percentage)
        end

        return false
    end
end