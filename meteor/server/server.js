// Mongo Collections
Items = new Meteor.Collection("items");
Favorites = new Meteor.Collection("favorites");
Requests = new Meteor.Collection("requests");

Meteor.startup(function () {
    collectionApi = new CollectionAPI();
    collectionApi.addCollection(Items, 'items');
    collectionApi.addCollection(Requests, 'requests');
    collectionApi.start();
});