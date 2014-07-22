module Skr
    module Access

        module RolesSerializer

            def self.type_to_str(klass)
                klass.to_s.demodulize.downcase
            end

            def self.to_json( user )
                {
                    :roles => user.roles.map{ | role |
                        {
                            type: type_to_str(role.class),
                            read: role.read.map{ |klass| type_to_str(klass) },
                            write: role.write.map{ |klass| type_to_str(klass) },
                            delete: role.delete.map{ |klass| type_to_str(klass) }
                        }
                    },
                    :locked_fields => LockedFields.all.map{ | klass, locks |
                        {
                            type: type_to_str(klass),
                            fields: locks.inject({}){ |h,kv| h[kv.first] = kv.last.map{ |role| type_to_str(role) }; h }
                        }
                    }
                }
            end
        end

    end
end
