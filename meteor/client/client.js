// Constants
var DEFAULT_IMG_URL = "http://www.sdtimes.com/blog/post/2010/image.axd?picture=2010%2F7%2Fclick_here.png";
var DEFAULT_NAME = "Click here to change name";
var DEFAULT_OWNER = "Click here to change owner";
var DEFAULT_DESCRIPTION = "Click here to change the description of the item";
var DEFAULT_COMMERCE_URL = "Click here to change the commerce URL";

// Namespace
var MustardSeed = {};
MustardSeed.googleApiLoaded = false;

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

function enableGoogleVisualization() {
    MustardSeed.googleApiLoaded = true;
}

////////// Items //////////
Template.items.items = function() {
    return Items.find({}, {sort: {"_id": 1}});
};

Template.items.events = {
    'mousedown .item': function() {
        Router.setItem(this._id);
    }
};

////////// Item Detail //////////
Template.item_detail.item = function() {
    var item_id = Session.get("item_id");
    console.log(item_id);
    return Items.findOne({_id: item_id});
};

Template.item_detail.format = function() {
    Meteor.defer(function() {
        //$(".item-detail h1").fitText(1.5);
    });
};

/* = function() {
    var item_id = Session.get("item_id");
    console.log(item_id);
    return Items.find({id: item_id});
};
*/

////////// Admin //////////
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

function blah() {
    console.log("BLAH!");
}

///////// Analytics //////////
function drawUserAcquisitionChart() {
    var data = google.visualization.arrayToDataTable([
      ['Date', 'Users'],
      ['Sunday', 2],
      ['Monday',  10],
      ['Tuesday',  11],
      ['Wednesday',  6],
      ['Thursday',  15],
      ['Friday', 23],
      ['Saturday', 6]
    ]);

    var options = {
      title: 'User Acquisition',
      backgroundColor: '#fafafa'
    };

    var chart = new google.visualization.LineChart(document.getElementById('num-users'));
    chart.draw(data, options);
};

function drawUserOverviewChart() {
    var data = google.visualization.arrayToDataTable([
      ['Time', 'Users'],
      ['Today', 1],
      ['This Week',  4],
      ['This Month',  24],
      ['Last 6 months', 145],
      ['Total', 221]
    ]);

    var options = {
      title: 'User Acquisition Overview',
      backgroundColor: '#fafafa'
    };

    var chart = new google.visualization.BarChart(document.getElementById('num-users-overview'));
    chart.draw(data, options);
}

function drawCharts() {
    // Check if the API is loaded
    if (!MustardSeed.googleApiLoaded) {
        console.log("Google API hasn't loaded");

        setTimeout(drawCharts(), 1500);
        return;
    }

    console.log("Drawing charts");
    drawUserAcquisitionChart();
    drawUserOverviewChart();
};

Template.analytics.draw = function() {
    Meteor.defer(function() {
        //console.log("Drawing charts");
        drawCharts();
    });
};

// Routing
var MSRouter = Backbone.Router.extend({
    routes: {
        "" : "main",
        "about" : "about",
        "admin" : "admin",
        "analytics" : "analytics",
        "requests" : "requests",
        ":item_id" : "item_id"
    },
    main: function() {
        // Redirect to standard page
        Session.set("page_id", null);
    },
    item_id: function(id) {
        Session.set("item_id", id);
        Session.set("page_id", "item_detail");
    },
    about: function() {
        Session.set("page_id", "about");
    },
    admin: function() {
        // Redirect to add page
        Session.set("page_id", "admin");
    },
    analytics: function() {
        Session.set("page_id", "analytics");
    },
    requests: function() {
        Session.set("page_id", "requests");
    },
    setItem: function(item_id) {
        this.navigate(item_id, true);
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

    // Set a callback to run when the Google Visualization API is loaded.
    google.setOnLoadCallback(enableGoogleVisualization());
});

// Jquery
$(function() {
    $('#items').masonry({
        itemSelector : '.item',
        columnWidth : 200
    });
    $('.item-detail').on('change', function() {
        console.log($this);
    });
});