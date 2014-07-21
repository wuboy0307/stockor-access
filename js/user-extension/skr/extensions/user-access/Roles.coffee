# N.B. Keep in sync with lib/skr/acces/roles.rb

Skr.Extension.UserAccess.define_roles = ->

    CRUD = ['create','read','update','delete']
    UNIVERSAL_GRANTS = [ Skr.Data.Address ]

    class Role
        @grant: (types,klasses...)->
            types = [types] if Skr.u.isString(types)
            klasses = Skr.u.map( klasses, (klass)->
                if Skr.u.isString(klass) then Skr.getPath(klass,"Skr.Data") else klass
            )
            for method in types
                this.prototype[method] = (this.prototype[method]|| []).concat( klasses )

        constructor: ->
            for method in CRUD
                this[method] = ( this[method] ||= [] ).concat( UNIVERSAL_GRANTS )

        can: (type,model)->
            if model instanceof Skr.Ampersand.Model
                model = model.constructor
            -1 != this[type].indexOf(model)

        canCreate:(model)->
            @can('create',model)

        canRead:(model)->
            @can('read',model)

        canUpdate:(model)->
            @can('update',model)

        canDelete:(model)->
            @can('delete',model)

    class Administrator extends Role
        can: -> true

    class CustomerSupport extends Role
        @grant CRUD,   'Customer', 'SalesOrder', 'Invoice'
        @grant 'read', 'PurchaseOrder', 'Vendor'

    class Purchasing extends Role
        @grant CRUD, 'Vendor', 'PurchaseOrder'

    class Accounting extends Role
        @grant CRUD,  'GlAccount', 'GlManualEntry', 'GlPosting', 'GlTransaction'
        @grant 'read','GlPeriod'

    RoleMap = {
        administrator    : Administrator
        customer_support : CustomerSupport
        purchasing       : Purchasing
        accounting       : Accounting
    }

    class Skr.Extension.UserAccess.RoleCollection
        constructor: (roles,user)->
            @all = Skr.u.map( roles, (role)->
                new RoleMap[role](user)
            ,this)

        grantsFor: (model)->
            ret = {}
            ret[method] = this.can(method,model) for method in CRUD
            ret

        can:(method,model)->
            !!Skr.u.detect( @all, (role)->role.can(method,model) )

        canCreate:(model)->
            this.can('create',model)

        canRead:(model)->
            this.can('read',model)

        canUpdate:(model)->
            this.can('update',model)

        canDelete:(model)->
            this.can('delete',model)
