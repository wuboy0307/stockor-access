module Skr

    module Access

        Skr::API::Root.post "login" do
            user = User.find_by(login: params.data.login)
            if user && user.authenticate(params.data.password)
                { success: true, message: "Login succeeded", data: user.workspace_data }
            else
                { success: false, message: "Login failed", data: {} }
            end
        end

    end


    Skr::API::Root.build_route User
end
