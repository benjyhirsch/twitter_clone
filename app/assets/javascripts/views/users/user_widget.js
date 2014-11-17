TwitterClone.Views.UserWidget = Backbone.CompositeView.extend({
  className: "widget user-widget",

  template: JST["users/widget"],

  initialize: function () {
    var view = this;
    view.addSubview(
      ".user-widget-tweet-form",
      new TwitterClone.Views.TweetForm({
        model: new TwitterClone.Models.Tweet({
          content: (this.model.id == TwitterClone.currentUser.id) ? "" : this.model.escape("username") + " "
        })
      })
    );
  },

  render: function () {
    this.$el.html(this.template({user: this.model}));
    this.attachSubviews();
    return this;
  }
})