TwitterClone.Routers.Router = Backbone.Router.extend({
  initialize: function (options) {
    this.$rootEl = options.$rootEl || $(options.rootEl)
  },

  routes: {
    '' : 'feedShow',
    'users/:id' : 'userShow',
    'tweets/:id' : 'tweetShow'
  },

  feedShow: function () {
    var view = new TwitterClone.Views.FeedShow();
    this._swapViews(view);
  },

  userShow: function (id) {
    var view = new TwitterClone.Views.UserShow({
      model: new TwitterClone.Models.User({id: id})
    });
    this._swapViews(view);
  },

  tweetShow: function (id) {
    var router = this;
    var tweet = new TwitterClone.Models.Tweet({id: id})
    tweet.fetch({
      success: function () {
        var view = new TwitterClone.Views.TweetShow({ model: tweet })
        router._swapViews(view);
      }
    })

  },

  _swapViews: function (view) {
    if (this._currentView) {
      this._currentView.remove()
    }

    this._currentView = view
    this.$rootEl.html(view.render().$el)
  }
});
