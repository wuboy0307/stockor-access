module Skr
    module Access

        module RolesSerializer

            def self.type_to_str(klass)
                klass.to_s.demodulize.downcase
            end

            def self.to_json( user )
                ret = []
                ret[:roles] = user.roles.map do | role |
                    {
                        type: type_to_str(role.class),
                        create: role.create.map{ |klass| type_to_str(klass) },
                        read: role.read.map{ |klass| type_to_str(klass) },
                        update: role.update.map{ |klass| type_to_str(klass) },
                        delete: role.delete.map{ |klass| type_to_str(klass) }
                    }
                end
                ret
            end
        end

    end
end
