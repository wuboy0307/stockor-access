class LoginDialog
    constructor: -> super
    bodyTemplateName: 'skr/extensions/user-access/login-dialog'
    size: 'md'
    title: 'Please sign in ...'

    events:
        'click .btn-primary': 'onLogin'

    buttons:
        login: { label: 'Login', type: 'primary', dismiss: true }

    onLogin: ->
        Skr.Data.User.attemptLogin(
            this.get('.login').value,
            this.get('.password').value
        )

    onShown: -> this.get('.login').focus()

Skr.Extension.UserAccess.LoginDialog = Skr.Component.ModalDialog.extend(LoginDialog)
