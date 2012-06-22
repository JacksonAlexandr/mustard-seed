// Mongo Collections
Items = new Meteor.Collection("items");
Favorites = new Meteor.Collection("favorites");

function is_favorite(id) {
    return Favorites.findOne({_id: id});
}

if (Meteor.is_client) {
    Template.items.items = function() {
        return Items.find({}, {sort: {time: -1}});
    };

    Template.admin.items = Template.items.items;

    Template.table_item.favorite = function() {
        return is_favorite(this._id);
    };

    Template.admin.events = {
        'click .add': function() {
            Items.insert({
                img_url: "",
                name: "",
                owner: "",
                description: ""
            });
        }
    };

    Template.table_item.events = {
        'click .delete': function() {
            console.log(this);
            //Items.remove({_id: this._id});
        }
    }

    var MSRouter = Backbone.Router.extend({
        routes: {
            "" : "main",
            "admin" : "admin",
            ":id" : "id"
        },
        main: function() {
            // Redirect to standard page
            Session.set("page_id", null);
        },
        id: function(id) {
            this.navigate("");
        },
        admin: function() {
            // Redirect to add page
            Session.set("page_id", "admin");
        }
    });

    // Register router
    Handlebars.registerHelper('content', function() {
        var page_id = Session.get("page_id");

        // Set default template
        if (!page_id) page_id = 'items';

        return Template[page_id]();
    });

    Meteor.startup(function() {
        Router = new MSRouter;

        Backbone.history.start({pushState: true});
    });
}

if (Meteor.is_server) {
    Meteor.startup(function () {
        collectionApi = new CollectionAPI();
        collectionApi.addCollection(Items, 'items');
        collectionApi.addCollection(Favorites, 'items/favorites');
        collectionApi.start();


    });
}