module Skr
    module Access


        def self._type_to_str(klass)
            klass.to_s.demodulize.underscore
        end

        def self.for_user( user )
            {
                :roles => user.roles.map{ | role |
                    {
                        type: _type_to_str(role.class),
                        read: role.read.map{ |klass| _type_to_str(klass) },
                        write: role.write.map{ |klass| _type_to_str(klass) },
                        delete: role.delete.map{ |klass| _type_to_str(klass) }
                    }
                },
                :locked_fields => LockedFields.definitions.map{ | klass, locks |
                    {
                        type: _type_to_str(klass),
                        locks: locks.each_with_object({}) do |(field, grants), result|
                             result[field] = grants.map do |grant|
                                 { role: _type_to_str(grant[:role]), only: grant[:only] }
                             end
                        end
                    }
                }
            }
        end
    end

end
