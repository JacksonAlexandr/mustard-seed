// Mongo Collections
Items = new Meteor.Collection("items");
Favorites = new Meteor.Collection("favorites");
Requests = new Meteor.Collection("requests");
Categories = new Meteor.Collection("categories");

Meteor.startup(function () {
    collectionApi = new CollectionAPI();
    collectionApi.addCollection(Items, 'items');
    collectionApi.addCollection(Requests, 'requests');
    collectionApi.addCollection(Categories, 'category');
    collectionApi.start();
});