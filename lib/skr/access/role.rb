# N.B. Keep in sync with js/user-extension/skr/extensions/user-access/Roles.coffee

module Skr
    module Access

        class Role
            class_attribute :read, :write, :delete

            def initialize(user)
                @user = user
            end

            def can_read?(model)
                read.include?(model)
            end

            def can_write?(model)
                write.include?(model)
            end

            def can_delete?(model)
                delete.include?(model)
            end

            class << self
                def grant_global_access(klass)
                    descendants.each do | child |
                        [ child.read, child.write, child.delete ].each{ |a| a.push(klass) }
                    end
                end

                def inherited(sub)
                    sub.read = []; sub.write = []; sub.delete = []
                end

                def grant( *klasses )
                    self.read.push( *klasses )
                    write.push( *klasses )
                    delete.push( *klasses )
                end

                def lock(klass, attribute)
                    LockedFields.lock( klass, attribute, self)
                end

                def lock_writes(klass, attribute)
                    LockedFields.lock( klass, attribute, self, :write)
                end

            end
        end

    end
end
