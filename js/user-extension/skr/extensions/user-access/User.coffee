
class User
    constructor: (attributes,@access_data)->
        super
        this

    derived:
        roles:
            deps: ['role_names']
            fn: ->
                new Skr.Extension.UserAccess.RoleCollection( @access_data )

    props_schema:
        string: [ 'id','login', 'email' ]
        array: ['role_names']
        object: ['options']


    canRead: (model,field)  -> this.roles.canRead(model,field)

    canWrite: (model,field) -> this.roles.canWrite(model,field)

    canDelete: (model)      -> this.roles.canDelete(model)

    isLoggedIn: ->
        true


    @attemptLogin = (login,password, options)->
        session = new Session( login: login, password: password )
        success = options.success
        options.success = (session)->
            Skr.current_user = session.user
            success.apply(options.scope, arguments)
        session.save(options)

class Session
    constructor: -> super
    api_path: 'login'
    props_schema:
        string: ['login','password','csrf_token']
        number: ['user_id']

    associations:
        user: { model: User }

Skr.Data.Model.extend(Session)

Skr.Extension.UserAccess.define_user = ->
    Skr.Data.User = Skr.Data.Model.extend(User)
