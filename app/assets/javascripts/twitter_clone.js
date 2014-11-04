window.TwitterClone = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    new Backbone.Routers.Router({ $rootEl: $("#backbone-el") });
    Backbone.history.start();
  }
};

$(document).ready(function(){
  TwitterClone.initialize();
});
