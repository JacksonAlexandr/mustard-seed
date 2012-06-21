// Mongo Collections
Items = new Meteor.Collection("items");
Favorites = new Meteor.Collection("favorites");

if (Meteor.is_client) {
    Template.items.items = function() {
        return Items.find({}, {sort: {time: -1}});
    };

    var MSRouter = Backbone.Router.extend({
        routes: {
            "" : "main",
            "add" : "add",
            ":id" : "id"
        },
        main: function() {
            // Redirect to standard page
            Session.set("page_id", null);
        },
        id: function(id) {
            this.navigate("");
        },
        add: function() {
            // Redirect to add page
            Session.set("page_id", "add");
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