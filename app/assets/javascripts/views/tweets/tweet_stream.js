TwitterClone.Views.TweetStream = Backbone.CompositeView.extend({

  tagName: "section",
  className: "stream",

  template: JST["tweets/stream"],

  initialize: function () {
    var view = this;
    this.collection.each(function (tweet) {
      view.addSubview(".stream-tweets", new TwitterClone.Views.ExpandableTweet({model: tweet}));
    });
  },

  render: function () {
    this.$el.html(this.template());
    this.attachSubviews();
    return this;
  }
})