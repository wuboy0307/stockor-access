module Skr
    module Access

        class LockedFields

            @definitions = Hash.new{ |fields,klass|
                fields[klass] = Hash.new{ |grants,field| grants[field] = [] }
            }

            def self.for(klass,attribute)
                @definitions[klass][attribute]
            end

            # Lock a given class and attribute to a given role
            def self.lock( klass, field, role )
                @definitions[klass][field] << role
            end

            def self.all
                @definitions
            end
        end

    end
end
