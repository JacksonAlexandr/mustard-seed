// Constants
var DEFAULT_IMG_URL = "http://www.sdtimes.com/blog/post/2010/image.axd?picture=2010%2F7%2Fclick_here.png";
var DEFAULT_NAME = "Click here to change name";
var DEFAULT_OWNER = "Click here to change owner";
var DEFAULT_DESCRIPTION = "Click here to change the description of the item";
var DEFAULT_COMMERCE_URL = "Click here to change the commerce URL";

// Mongo Collections
Items = new Meteor.Collection("items");
Favorites = new Meteor.Collection("favorites");
Requests = new Meteor.Collection("requests");

// Helper functions
function is_favorite(id) {
    return Favorites.findOne({item_id: id});
}

function set_prompt_value(v, def, id) {
    var value = prompt("Enter " + v, def);

    if (value)
        Items.update(id, {$set: {v: value}});
}

// Templating
Template.items.items = function() {
    return Items.find({}, {sort: {"_id": 1}});
};

Template.admin.favorite_items = function() {
    return Items.find({favorite: true});
};

Template.admin.items = Template.items.items;

Template.admin_item.favorite_checkbox = function () {
    return this.favorite ? 'checked="checked"' : '';
};

Template.admin_item.favorite_style = function () {
    return this.favorite ? 'class="favorite"' : '';
};

Template.admin_item.favorite_value = function() {
    return !this.favorite ? 'value="Favorite"' : 'value="Unfavorite"';
};

Template.requests.items = function() {
    return Requests.find({});
};

Template.admin.events = {
    'click input#add': function() {
        Items.insert({
            img_url: DEFAULT_IMG_URL,
            name: DEFAULT_NAME,
            owner: DEFAULT_OWNER,
            commerce_url: DEFAULT_COMMERCE_URL,
            description: DEFAULT_DESCRIPTION
        });
    }
};

Template.admin_item.events = {
    'click #delete': function() {
        if (confirm("Are you sure you want to delete this item?"))
            Items.remove({_id: this._id});
    },
    'click #favorite': function(e) {
        Items.update(this._id, {$set: {favorite: !this.favorite}});
    },
    'click #name': function(e) {
        var value = prompt("Enter Name", this.name);

        if (value) Items.update(this._id, {$set: {name: value}});
    },
    'click #owner': function(e) {
        var value = prompt("Enter Owner", this.owner);

        if (value) Items.update(this._id, {$set: {owner: value}});
    },
    'click #description': function(e) {
        var value = prompt("Enter Description", this.description);

        if (value) Items.update(this._id, {$set: {description: value}});
    },
    'click #commerce_url': function(e) {
        var value = prompt("Enter Commerce URL", this.commerce_url);

        if (value) Items.update(this._id, {$set: {commerce_url: value}});
    },
    'click #image': function(e) {
        var value = prompt("Enter Image URL", this.img_url);

        if (value) Items.update(this._id, {$set: {img_url: value}});
    },
};

// Routing
var MSRouter = Backbone.Router.extend({
    routes: {
        "" : "main",
        "admin" : "admin",
        "requests" : "requests",
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
    },
    requests: function() {
        Session.set("page_id", "requests");
    }
});

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