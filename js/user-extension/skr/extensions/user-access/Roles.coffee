
RWD = ['read','write','delete']
#UNIVERSAL_GRANTS = -> [ Skr.Data.Address ]


class Role

    constructor: (config={})->
        @type = config.type
        for method in RWD
            this[method] = Skr.u.map(config[method],klassFor) #).concat( UNIVERSAL_GRANTS )

    can: (type,model)->
        -1 != this[type].indexOf(model)


Skr.Extension.UserAccess.RoleMap = {
    administrator    : Administrator
}

# The admin is special and can do anything
class Administrator extends Role
    can: -> true

class Skr.Extension.UserAccess.RoleCollection
    constructor: (access={})->
        Skr.u.defaults(access, { roles: [], locked_fields: [] })
        @roles = []
        for role in access.roles
            klass = Skr.Extension.UserAccess.RoleMap[role.type] || Role
            @roles.push( new klass(role) )
        @locked_fields = {}
        for lock in access.locked_fields
            if klass = klassFor(lock.type)
                @locked_fields[ klass ] = locks = {}
                locks[field] = grants for field, grants of lock.locks



    can:(method,model,field)->
        if model instanceof Skr.Data.Model
            model = model.constructor

        if field && ( locks = @locked_fields[model] ) && ( grants = locks[field] )
            for grant in grants
                if grant.only && grant.only != method
                    return this.testModelAccess(method,model)
                else
                    for role in @roles
                        return true if role.type == grant.role
            return false
        else
            return this.testModelAccess(method,model)

    testModelAccess:(method,model)->
        !!Skr.u.detect( @roles, (role)->role.can(method,model) )

    canRead:(model,field)->
        this.can('read',model,field)

    canWrite:(model,field)->
        this.can('write',model,field)

    canDelete:(model)->
        this.can('delete',model)


klassFor = (identifier)->
    name = Skr.u.chain(identifier).titleize().gsub(' ','').value()
    Skr.Data[name] ||
        Skr.warn("Role Data object not found for #{identifier}")
