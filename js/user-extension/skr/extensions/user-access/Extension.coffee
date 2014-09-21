class UserAccessExtension

    constructor: -> super

    identifier: 'users-management'

    onRegistered: ->
        Skr.Data.Address.prototype.modelForAccess = ->
            this.parent || this

    setBootstrapData: (data)->
        Skr.Extension.UserAccess.user_data=data
        Skr.UI.current_user = new Skr.Data.User( data.user, data.access)

    onAvailable: (application)->
        @dialog = new Skr.Extension.UserAccess.LoginDialog
        Skr.UI.on("change:current_user", this.maybeShowLogin, this)
        this.maybeShowLogin()

    maybeShowLogin: ->
        @dialog.show() unless Skr.UI.current_user.isLoggedIn()


Skr.Extension.Base.extend( UserAccessExtension )
