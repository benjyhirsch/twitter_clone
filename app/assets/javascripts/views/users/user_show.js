TwitterClone.Views.UserShow = Backbone.CompositeView.extend({

  template: JST['users/show'],

  initialize: function () {
    var view = this;
    this.model.fetch({
      success: function () {
        view.addSubview(".stream-container", new TwitterClone.Views.TweetStream({
          collection: view.model.tweets
        }))
      }
    })

    this.listenTo(this.model, "sync", this.render.bind(this));
  },

  render: function () {
    this.$el.html(this.template({user: this.model}));
    this.attachSubviews();
    return this;
  }
});
