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

            # @param model [Skr::Model]
            # @param attribute [Symbol]
            # @return [Boolean] Can the User view the model?
            def can_read?(model, attribute = nil)
                test_access(model, attribute, :read){ |role| role.can_read?(model) }
            end

            # @param model [Skr::Model]
            # @param attribute [Symbol]
            # @return [Boolean] Can the User create and update the model?
            def can_write?(model, attribute = nil)
                test_access(model, attribute, :write){ |role| role.can_write?(model) }
            end

            # @param model [Skr::Model]
            # @return [Boolean] Can the User delete the model?
            def can_delete?(model)
                @roles.each{ |role| role.can_delete?(model) }
            end

            # @return [Array<symbol>] list of roles
            def to_sym
                @roles.map{ |r| r.class.to_s.demodulize.downcase.to_sym }
            end

            def each
                @roles.each{|r| yield r}
            end

          private

            # Test if the given roles grant access to the model
            def test_access(model, attribute, access_type)
                # Check if the attribute is locked
                # If it is, the locks determine access, otherwise use the model's grants
                roles = LockedFields.roles_needed_for(model, attribute, access_type)
                if roles.empty?
                    return !!@roles.detect { |role| yield role }.present?
                else
                    !!roles.find { |role| @roles.map(&:class).include?(role) }
                end
            end

        end

    end
end

require_relative "roles/accounting"
require_relative "roles/customer_support"
require_relative "roles/purchasing"

# n.b. administrator comes last so it can
# unlock all the locked fields
require_relative "roles/administrator"
