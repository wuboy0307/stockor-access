module Skr

    API::Root.post "login" do
        user = User.find_by(login: params.data.login)
        if user && user.authenticate(params.data.password)
            { success: true, message: "Login succeeded", data: user.workspace_data }
        else
            { success: false, message: "Login failed", data: {} }
        end
    end

    API::Root.delete "login/:id" do
        session.destroy
        { success: true, message: "Logout succeeded", data: {} }
    end

    API::Root.build_route User

end
