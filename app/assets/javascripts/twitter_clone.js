window.TwitterClone = {
  Models: {},
  Collections: {},
  Views: {},
  Routers: {},
  initialize: function() {
    

    var session = new TwitterClone.Models.Session();
    session.fetch({success: function () {
      TwitterClone.currentUser = session.user
      TwitterClone.feed = new TwitterClone.Collections.Feed();
      new TwitterClone.Routers.Router({ $rootEl: $("#backbone") });
      Backbone.history.start();
    }});
  }
};

$(document).ready(function(){
  TwitterClone.initialize();
});

