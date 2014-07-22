module Skr
    module Access

        class RoleCollection
            include Enumerable

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
            def can_read?(model, attribute = nil)
                test(model,attribute){ |role| role.can_read?(model, attribute) }
            end

            # @param model [Skr::Model]
            # @param attribute [Symbol]
            # @return [Boolean] Can the User create and update the model?
            def can_write?(model, attribute = nil)
                test(model,attribute){ |role| role.can_write?(model, attribute) }
            end

            # @param model [Skr::Model]
            # @param id [Numberic] the id for the model
            # @return [Boolean] Can the User delete the model?
            def can_delete?(type, model, id = nil)
                test(model,attribute){ |role| role.can_delete?(model, attribute) }
            end

            # @param roles Role
            # @return [Boolean] Does the collection include any of the given role(s)?
            def include?(*test_roles)
                @roles.detect do |role|
                    test_roles.include?(role)
                end
            end

            # @return [Array<symbol>] list of roles
            def to_sym
                @roles.map{ |r| r.class.to_s.demodulize.downcase.to_sym }
            end

            def each
                @roles.each{|r| yield r}
            end

          private

            def test(model,attribute)
                if attribute && locks = LockedFields.for(model,attribute)
                    return include?(*locks)
                else
                    @roles.each{ |role| return true if yield role }
                    return false
                end
            end

        end

    end
end

require 'require_all'
require_rel 'roles/*.rb'
