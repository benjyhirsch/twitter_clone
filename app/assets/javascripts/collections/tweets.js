TwitterClone.Collections.Tweets = Backbone.Collection.extend({

  model: TwitterClone.Models.Tweet,
  url: "api/tweets",

  comparator: function (tweet) {
    return -1 * tweet.timestamp().valueOf();
  }
});