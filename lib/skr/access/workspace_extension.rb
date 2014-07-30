module Skr
    module Access

        class WorkspaceExtension < Workspace::Extension

            def identifier
                'users-management'
            end

            def bootstrap_data(view)
                if (user_id = view.session[:user_id]) && (user = Skr::User.where( id: user_id ).first)
                    user.workspace_data
                else
                    {}
                end
            end

            def js_class_name
                'Skr.Extension.UserAccess'
            end

            def logical_path
                'skr/extensions/user-access'
            end

            def asset_path
                Pathname.new(__FILE__).dirname.join("../../../js/user-extension").realpath
            end

        end
    end


end
