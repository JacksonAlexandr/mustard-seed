// Namespace + Constants
var MustardSeed = {};
MustardSeed.DEFAULT_CATEGORY = "Uncategorized";

// Mongo Collections
Items = new Meteor.Collection("items");
Favorites = new Meteor.Collection("favorites");
Requests = new Meteor.Collection("requests");
Categories = new Meteor.Collection("categories");

// Helper functions
function set_prompt_value(v, def, id) {
    var value = prompt("Enter " + v, def);

    if (value)
        Items.update(id, {$set: {v: value}});
}

// Finds the default Category object or creates it if it doesn't exist
function getDefaultCategory() {
    var defaultCategory = Categories.findOne({name: MustardSeed.DEFAULT_CATEGORY});
    if (!defaultCategory) {
        defaultCategory.name = MustardSeed.DEFAULT_CATEGORY;
        defaultCategory._id = Categories.insert({name: MustardSeed.DEFAULT_CATEGORY});
    }

    return defaultCategory;
}

////////// Items //////////
Template.items.items = function() {
    var categoryId = Session.get("category_id");
    if (categoryId === null)
        return Items.find({category_id: {$ne:""}}, {sort: {"_id": 1}});
    else
        return Items.find({category_id: categoryId, category_id: {$ne:""}}, {sort: {"_id": 1}});
};

Template.items.category = function() {
    var categoryId = Session.get("category_id");
    if (categoryId === null)
        return {name: "All Items"};

    return Categories.findOne({_id: categoryId});
};

Template.items.categories = function() {
    return Categories.find({});
};

Template.items.events = {
    'click .item': function() {
        Router.setItem(this._id);
    },
    'click .category-id': function() {
        var categoryId = this._id;
        console.log("Clicked on Category " + this.name);
        Session.set("category_id", categoryId);
    },
    'click #all-items': function() {
        Session.set("category_id", null);
    }
};

////////// Item Detail //////////
Template.item_detail.item = function() {
    var item_id = Session.get("item_id");
    return Items.findOne({_id: item_id});
};

Template.item_detail.category = function() {
    return Categories.findOne({_id: this.category_id});
};

Template.item_detail.categories = function() {
    return Categories.find({});
};

Template.item_detail.events = {
    'click .category-id': function() {
        // Update Item's category
        var item_id = Session.get("item_id");
        console.log("Item ID: " + item_id);
        console.log("New Category: [" + this._id + "] " + this.name);
        Items.update({_id: item_id}, {$set: {category_id: this._id}});
    },
    'click #add-category': function() {
        var item_id = Session.get("item_id");
        var newCategory = prompt("Add a Category", "Input category name");
        var newCategoryId = Categories.insert({name: newCategory});

        Items.update({_id: item_id}, {$set: {category_id: newCategoryId}});
    },
};

////////// Requests //////////
Template.requests.items = function() {
    return Requests.find({added: false});
};

Template.requests.added_items = function() {
    return Requests.find({added: true});
};

Template.requests.events = {
    'click .added': function() {
        Requests.update({_id: this._id}, {$set: {added: true}});
    }
}

////////// Admin //////////
Template.admin.items = function() {
    return Items.find({});
}

Template.admin.events = {
    'click #add': function() {
        Router.navigate("add", {trigger: true});
    },
    'click .thumbnail': function() {
        Router.editItem(this._id);
    },
};

Template.admin_item.events = {
    'click #delete-item': function() {
        if (confirm("Are you sure you want to delete this item?"))
            Items.remove({_id: this._id});
        else
            Router.navigate('/admin', {trigger: true});
    }
};

////////// Edit //////////
Template.edit_item.item = function() {
    return Items.findOne({_id: Session.get("item_id")});
};

Template.edit_item.favorited = function() {
    return (this.category_id !== "");
};

Template.edit_item.events = {
    'click #submit': function() {
        var name = document.getElementById("name");
        var owner = document.getElementById("owner");
        var img_url = document.getElementById("img-url");
        var commerce_url = document.getElementById("commerce-url");
        var video_url = document.getElementById("video-url");
        var description = document.getElementById("description");

        // Check if favorited
        var favorited = document.getElementById("favorited");
        var categoryId = "";
        if (favorited.checked) {
            categoryId = this.category_id;

            // If item doesn't have a category id, assign it to the default
            if (categoryId === "")
                categoryId = getDefaultCategory()._id;
        }

        // Error checking
        var valid = [];
        valid.push(checkInput(name));
        valid.push(checkInput(owner));
        valid.push(checkInput(img_url));
        valid.push(checkInput(commerce_url));
        valid.push(checkInput(video_url));
        valid.push(checkInput(description));
        for (status in valid)
            if (!status) return false;

        Items.update({_id: this._id}, {$set: {
            name: name.value,
            owner: owner.value,
            img_url: img_url.value,
            commerce_url: commerce_url.value,
            video_url: video_url.value,
            description: description.value,
            category_id: categoryId
        }});

        // Redirect to /admin?
        Router.setItem(this._id);
        return false;
    }
}

////////// Add //////////
function checkInput(e) {
    if (!e.value) {
        $(e).closest('.control-group').addClass('error');
        return false;
    }
    else {
        $(e).closest('.control-group').removeClass('error');
        return true;
    }
}

Template.add_item.events = {
    'click button#submit': function(e) {
        var name = document.getElementById("name");
        var owner = document.getElementById("owner");
        var img_url = document.getElementById("img-url");
        var commerce_url = document.getElementById("commerce-url");
        var video_url = document.getElementById("video-url");
        var description = document.getElementById("description");

        // Error checking
        var valid = [];
        valid.push(checkInput(name));
        valid.push(checkInput(owner));
        valid.push(checkInput(img_url));
        valid.push(checkInput(commerce_url));
        valid.push(checkInput(video_url));
        valid.push(checkInput(description));
        for (status in valid)
            if (!status) return false;
        
        // Check if user has favorited the item
        var category = {};
        var favorited = document.getElementById("favorited");
        if (favorited.checked) {
            category = getDefaultCategory();
        }
        else {
            // No category
            category._id = "";
        }

        var newItem = Items.insert({
            name: name.value,
            owner: owner.value,
            img_url: img_url.value,
            commerce_url: commerce_url.value,
            video_url: video_url.value,
            description: description.value,
            category_id: category._id
        });

        Router.setItem(newItem);
        return false;
    }
};

// Routing
var MSRouter = Backbone.Router.extend({
    routes: {
        "" : "main",
        "about" : "about",
        "admin" : "admin",
        "add" : "add",
        "analytics" : "analytics",
        "tags" : "requests",
        ":item_id" : "item_id",
        "edit/:item_id" : "edit_item"
    },
    main: function() {
        // Redirect to standard page
        Session.set("page_id", null);
        Session.set("category_id", null);
    },
    item_id: function(id) {
        Session.set("item_id", id);
        Session.set("page_id", "item_detail");
    },
    edit_item: function(id) {
        Session.set("item_id", id);
        Session.set("page_id", "edit_item");
    },
    about: function() {
        Session.set("page_id", "about");
    },
    admin: function() {
        // Redirect to add page
        Session.set("page_id", "admin");
    },
    add: function() {
        Session.set("page_id", "add_item");
    },
    analytics: function() {
        Session.set("page_id", "analytics");
    },
    requests: function() {
        Session.set("page_id", "requests");
    },
    setItem: function(item_id) {
        this.navigate(item_id, {trigger: true, replace: false});
    },
    editItem: function(item_id) {
        this.navigate('edit/' + item_id, {trigger: true});
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

// Jquery
$(function() {
    $('#items').masonry({
        itemSelector : '.thumbnail'
    });
});