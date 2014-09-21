module Skr
    module Access

        module Roles

            class Administrator < Role
                self.grant( *Skr::Model.descendants )

                LockedFields.definitions.each do | klass, fields |
                    fields.each do |field, grants|
                        grants.push({ role: self, only: nil })
                    end
                end
            end

        end

    end
end
