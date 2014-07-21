class User
    constructor: -> super

    derived:
        roles:
            deps: ['role_names']
            fn: ->
                new Skr.Extension.UserAccess.RoleCollection( this.role_names, this )

    props_schema:
        string: [ 'id','login', 'email' ]
        array: ['role_names']
        object: ['options']


Skr.Extension.UserAccess.define_user = ->
    Skr.Data.User = Skr.Data.Model.extend(User)
