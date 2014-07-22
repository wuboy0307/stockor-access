# N.B. Keep in sync with js/user-extension/skr/extensions/user-access/Roles.coffee

module Skr
    module Access

        class Role
            class_attribute :read, :write, :delete

            def self.grant_global_access(klass)
                self.descendants.each do | child |
                    [ child.read, child.write, child.delete ].each{ |a| a.push(klass) }
                end
            end

            def self.inherited(sub)
                sub.read = []; sub.write = []; sub.delete = []
            end

            def self.grant( *klasses )
                self.read.push( *klasses )
                self.write.push( *klasses )
                self.delete.push( *klasses )
            end

            def self.lock( klass, attribute )
                LockedFields.lock klass, attribute, self # Customer, :terms_id, to: Accounting, only: :write
            end

            def initialize(user)
                @user = user
            end

            def can?(type, model, data)
                case type
                when :read   then can_read?(model,   data)
                when :write  then can_write?(model,  data)
                when :delete then can_delete?(model, data)
                end
            end

            def can_read?(model,params)
                read.include?(model)
            end

            def can_write?(model, attribute)
                write.include?(model)
            end

            def can_delete?(model)
                delete.include?(model)
            end
        end

    end
end
