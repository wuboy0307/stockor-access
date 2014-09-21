module Skr
    module Access

        class WorkspaceExtension < Workspace::Extension

            self.identifier   = 'users-management'
            self.logical_path = 'skr/extensions/user-access'
            self.asset_path   = Pathname.new(__FILE__).dirname.join("../../../js/user-extension").realpath

            def bootstrap_data(view)
                if (user_id = view.session[:user_id]) && (user = Skr::User.where( id: user_id ).first)
                    user.workspace_data
                else
                    {}
                end
            end
        end

    end
end
