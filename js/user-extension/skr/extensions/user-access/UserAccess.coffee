class UserAccess

    identifier: 'users-management'

    onDataAvailable: ->
        Skr.Extension.UserAccess.define_user()
        Skr.Extension.UserAccess.define_roles()

    onAvailable: ->

    setBootstrapData: (data)->
        Skr.current_user = new Skr.Data.User( data.user )


Skr.Extension.UserAccess = Skr.Extension.Base.extend( UserAccess )