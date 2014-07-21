module Skr
    module Access

        class RoleCollection

            def initialize(user)
                @roles ||= user.role_names.map{ |name|
                    "Skr::Access::Roles::#{name.classify}".safe_constantize
                }.compact.map{ |klass| klass.new(user) }
            end

            def exposed_data
                @roles.map{ |role| role.class.to_s.demodulize.downcase }
            end

            def can?(type, model, data)
                !!@roles.detect{ |role| role.can(type, model, data) }
            end

            # @param model [Skr::Model]
            # @param attribute [Symbol]
            # @return [Boolean] Can the User view the model?
            def can_read?(model, attribute = '')
                !!@roles.detect{ |role| role.can_read?(model, attribute) }
            end

            # @param model [Skr::Model]
            # @param attribute [Symbol]
            # @return [Boolean] Can the User create and update the model?
            def can_write?(model, attribute = nil)
                !!@roles.detect{ |role| role.can_write?(model, attribute) }
            end

            # @param model [Skr::Model]
            # @param id [Numberic] the id for the model
            # @return [Boolean] Can the User delete the model?
            def can_delete?(type, model, id=nil)
                !!@roles.detect{ |role| role.can_delete?(model, attribute) }
            end

        end

    end
end


require 'require_all'
require_rel 'roles/*.rb'
