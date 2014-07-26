class UserAccessRegistration

    identifier: 'users-management'

    whenRegistered: ->
        Skr.Extension.UserAccess.define_user()

    setBootstrapData: (data)->
        Skr.current_user = new Skr.Data.User( data.user, data.access)


Skr.Extension.Base.extend( UserAccessRegistration )