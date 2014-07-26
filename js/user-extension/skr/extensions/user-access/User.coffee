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


Skr.Extension.UserAccess.define_user = ->
    Skr.Data.User = Skr.Data.Model.extend(User)
