// Mongo Collections
Items = new Meteor.Collection("items");
Favorites = new Meteor.Collection("favorites");

function is_favorite(id) {
    return Favorites.findOne({item_id: id});
}

if (Meteor.is_client) {
    Template.items.items = function() {
        return Items.find({}, {sort: {time: -1}});
    };

    Template.admin.favorite_items = function() {
        return Items.find({favorite: true});
    };

    Template.admin.items = Template.items.items;

    Template.table_item.favorite_checkbox = function () {
        return this.favorite ? 'checked="checked"' : '';
    };

    //Template.table_item.favorite = function() {
    //   return is_favorite(this._id);
    //};

    Template.admin.events = {
        'click input#add': function() {
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
            if (confirm("Are you sure you want to delete this item?"))
                Items.remove({_id: this._id});
        },
        'click .favorite': function(e) {
            Items.update(this._id, {$set: {favorite: !this.favorite}});
        },
        'keyup input#name': function(e) {
            var value = e.target.value;
            Items.update(this._id, {$set: {name: value}});
            e.target.value = value;
        },
        'keyup input#owner': function(e) {
            var value = e.target.value;
            Items.update(this._id, {$set: {owner: value}});
            e.target.value = value;
        },
        'keyup textarea#description': function(e) {
            var value = e.target.value;
            Items.update(this._id, {$set: {description: value}});
            e.target.value = value;
        },
        'click img': function(e) {
            var url = prompt("Enter image url", this.img_url);
            if (url)
                Items.update(this._id, {$set: {img_url: url}});
        }
    };

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