TwitterClone.Views.TweetShow = Backbone.CompositeView.extend({

  className: "tweet-show",

  template: JST["tweets/show"],

  initialize: function () {
    var view = this;
    view.addSubview(".stream", new TwitterClone.Views.ExpandableTweet({model: this.model, alwaysExpanded: true}));
  },

  render: function () {
    this.$el.html(this.template());
    this.attachSubviews();
    return this;
  }
})