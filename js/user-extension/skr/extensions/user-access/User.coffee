class User

    constructor: (attributes,access)->
        super
        this.access_data = access

    derived:
        roles:
            deps: ['role_names', 'access_data']
            fn: ->
                new Skr.Extension.UserAccess.RoleCollection( @access_data )
    session:
        access_data: 'object'

    props:
        id:         { type: "integer", required:true }
        login:       'string'
        name:        'string'
        email:       'string'
        role_names:  'array'
        options:     'object'

    canRead: (model,field)  -> this.roles.canRead(model,field)
    canWrite: (model,field) -> this.roles.canWrite(model,field)
    canDelete: (model)      -> this.roles.canDelete(model)

    isLoggedIn: ->
        true

    logout: ->
        session = new Session( id: this.id )
        session.destroy()
            .then -> Skr.UI.current_user = new Skr.Data.UserProxy

    @attemptLogin = (login,password, options)->
        session = new Session( login: login, password: password )
        success = options.success
        session.save(Skr.u.extend(options,{
            success: (session)->
                Skr.UI.current_user = new User(session.user, session.access)
                success.apply(options.scope, arguments)
        }))

Skr.Data.User = Skr.Data.Model.extend(User)

class Session
    constructor: -> super
    api_path: 'login'
    props:
        id:         'integer'
        login:      'string'
        password:   'string'
        csrf_token: 'string'
        access:     'object'
        user:       'object'

Skr.Data.Model.extend(Session)
