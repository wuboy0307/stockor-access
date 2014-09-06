class User

    constructor: (attributes,@access_data)-> super

    derived:
        roles:
            deps: ['role_names']
            fn: ->
                new Skr.Extension.UserAccess.RoleCollection( @access_data )

    props:
        id:         { type: "integer", required:true }
        login:      'string'
        name:       'string'
        email:      'string'
        role_names: 'array'
        options:    'object'

    canRead: (model,field)  -> this.roles.canRead(model,field)
    canWrite: (model,field) -> this.roles.canWrite(model,field)
    canDelete: (model)      -> this.roles.canDelete(model)

    isLoggedIn: ->
        true

    @attemptLogin = (login,password, options)->
        session = new Session( login: login, password: password )
        success = options.success
        session.save(Skr.u.extend(options,{
            success: (session)->
                Skr.current_user = new User(session.user, session.access)
                success.apply(options.scope, arguments)
        }))

class Session
    constructor: -> super
    api_path: 'login'
    props:
        login:      'string'
        password:   'string'
        csrf_token: 'string'
        access:     'object'
        user:       'object'

Skr.Data.Model.extend(Session)

Skr.Extension.UserAccess.define_user = ->
    Skr.Data.User = Skr.Data.Model.extend(User)
