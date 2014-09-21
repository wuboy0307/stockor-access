module Skr

    # A postal address with optional email and phone number
    # By default all fields may be left blank.
    #
    # Validations may be selectively enabled by using the #enable_validations method
    class User < Skr::Model
        extend Forwardable

        has_secure_password

        validates :login, :name, :email, presence: true
        validates :email, email: true, uniqueness: { case_sensitive: false }
        validates :password, length: { minimum: 6 }, allow_nil: true

        def roles
            @cached_roles ||= Access::RoleCollection.new(self)
        end

        def_delegators :roles, :can_create?, :can_read?, :can_update?, :can_delete?

        def workspace_data
            my_data = attributes.slice('id','login','name','email','created_at',
              'created_by','updated_at','updated_by','role_names')
            { user: my_data, access: Access.for_user(self) }
        end

        # @param model [Skr::Model]
        # @param attribute [Symbol]
        # @return [Boolean] Can the User view the model?
        def can_read?(model, attribute = nil)
            roles.can_read?(model, attribute)
        end

        # @param model [Skr::Model]
        # @param attribute [Symbol]
        # @return [Boolean] Can the User create and update the model?
        def can_write?(model, attribute = nil)
            roles.can_write?(model, attribute)
        end

        # @param model [Skr::Model]
        # @param id [Numberic] the id for the model
        # @return [Boolean] Can the User delete the model?
        def can_delete?(type, model, id=nil)
            roles.can_delete?(model, id)
        end

    end

    Core.config.user_model = User
    Skr::Model.descendants.each do |klass|
        klass.reflect_on_association(:updated_by).options[:class_name]='Skr::User'
        klass.reflect_on_association(:created_by).options[:class_name]='Skr::User'
    end
end
