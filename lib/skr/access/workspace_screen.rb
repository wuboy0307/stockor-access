require 'pathname'
require 'skr/workspace'

module Skr
    module Access

        class WorkspaceScreen < Workspace::ScreenDefinition

            def specification
                {
                    id: 'users-management',
                    title: 'Users',
                    description: 'Create and maintain Users',
                    icon: 'icon-user',
                    group_id: 'customers',
                    view: 'UserManagement',
                    model: 'User'
                }
            end

            def asset_path
                Pathname.new(__FILE__).dirname.join("../../../js/screen").realpath
            end

            def asset_file_names
                [ 'skr/access/users-management.js' ]
            end

        end

    end

end
