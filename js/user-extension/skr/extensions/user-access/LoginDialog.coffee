class LoginDialog
    constructor: -> super
    bodyTemplateName: 'skr/extensions/user-access/login-dialog'
    size: 'md'
    title: 'Please sign in …'

    events:
        'click .btn-primary': 'onLogin'

    buttons:
        login: { label: 'Login', type: 'primary' }

    onLogin: (ev)->
        msg = this.$('.alert').hide()
        mask = new Skr.View.TimedMask(this.$el, "Attempting Login …")
        Skr.Data.User.attemptLogin(this.get('.login').value, this.get('.password').value,{
            scope: this
            success: ->
                mask.displaySuccess("Login Success!")
                Skr.u.delay( =>
                    @close()
                ,mask.defaultTimeout)
            error: (session,reply)->
                msg.show().text(reply.message)
                this.$('.alert').show().text(reply.message)
        })

    onShown: -> this.query('.login').focus()

Skr.Extension.UserAccess.LoginDialog = Skr.Component.ModalDialog.extend(LoginDialog)
