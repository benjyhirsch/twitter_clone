TwitterClone.Collections.Feed = Backbone.Collection.extend({

  model: TwitterClone.Models.Tweet,
  url: "api/feed",

  comparator: function (tweet) {
    return -1 * tweet.timestamp().valueOf();
  }

});