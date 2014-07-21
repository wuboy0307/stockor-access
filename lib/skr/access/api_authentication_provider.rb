require 'skr/api/configuration'

module Skr
    module Access
        class AuthenticationProvider

            def initialize(environment:nil, params:nil)
                @environment = environment
                @params      = params
            end

            def current_user
                @current_user ||= Skr::User.where(id: @environment['rack.session'][:user_id]).first
            end

            def error_message
                current_user ? "User not found" : ''
            end

            def allowed_access_to?(klass, type)
                return false if current_user.nil?
                case type
                    when 'GET'
                        current_user.can_read?(klass,@params)
                    when 'POST','PATCH','PUT'
                        current_user.can_write?(klass,@params)
                    when 'DELETE'
                        current_user.can_delete?(klass)
                    else
                        false
                end
            end
        end

        API.config.authentication_provider = AuthenticationProvider

    end
end
