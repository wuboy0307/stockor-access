class UserAccessRegistration

    constructor: -> super

    identifier: 'users-management'

    onRegistered: ->
        Skr.Extension.UserAccess.define_user()

    setBootstrapData: (data)->
        Skr.current_user = new Skr.Data.User( data.user, data.access)

    onAvailable: (application)->
        dialog = new Skr.Extension.UserAccess.LoginDialog
        dialog.show() unless Skr.current_user.isLoggedIn()


Skr.Extension.Base.extend( UserAccessRegistration )
