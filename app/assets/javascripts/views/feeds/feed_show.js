TwitterClone.Views.FeedShow = Backbone.CompositeView.extend({

  template: JST["feeds/show"],

  initialize: function () {
    var view = this;
    TwitterClone.feed.fetch({
      success: function () {
        view.addSubview(".stream-container", new TwitterClone.Views.TweetStream({collection: TwitterClone.feed}));
        var userWidget = new TwitterClone.Views.UserWidget({model: TwitterClone.currentUser});
        userWidget.$el.addClass("dashboard-user-widget")
        view.addSubview(".sidebar", userWidget);
      }
    })
  },

  render: function () {
    this.$el.html(this.template());
    this.attachSubviews();
    return this;
  },
})