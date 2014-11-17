TwitterClone.Views.SingleTweet = Backbone.View.extend({

  tagName: "article",
  className: "tweet",

  template: JST["tweets/tweet"],

  initialize: function (options) {
    if (options["secondary"]) { 
      this.$el.addClass("secondary"); 
    }
    
    this.listenTo(this.model, 'change', this.render.bind(this))
  },

  render: function () {
    this.$el.html(this.template({tweet: this.model, secondary: this.secondary}));
    this.$(".livestamp").livestamp();
    return this;
  },

  events: {
    "click .retweet-button" : "toggleRetweet",
    "click .favorite-button" : "toggleFavorite"
  },

  toggleRetweet: function (event) {
    event.preventDefault();
    var view = this;
    var $retweetButton = $(event.currentTarget)
    if (this.model.get("retweeted")) {
      var retweet = new TwitterClone.Models.Retweet({id: "placeholder"}, {tweet: this.model})
      retweet.destroy({
        success: function () {
          view.model.set({"retweeted" : false, "num_retweets" : view.model.get("num_retweets") - 1});
        }
      });
    } else {
      var retweet = new TwitterClone.Models.Retweet({}, {tweet: this.model})
      retweet.save({}, {
        success: function () {
          view.model.set({"retweeted" : true, "num_retweets" : view.model.get("num_retweets") + 1});
        }
      })
    }
  },


  toggleFavorite: function (event) {
    event.preventDefault();
    var view = this;
    var $favoriteButton = $(event.currentTarget)
    if (this.model.get("favorited")) {
      var favorite = new TwitterClone.Models.Favorite({id: "placeholder"}, {tweet: this.model})
      favorite.destroy({
        success: function () {
          view.model.set({"favorited" : false, "num_favorites" : view.model.get("num_favorites") - 1});
        }
      });
    } else {
      var favorite = new TwitterClone.Models.Favorite({}, {tweet: this.model})
      favorite.save({}, {
        success: function () {
          view.model.set({"favorited" : true, "num_favorites" : view.model.get("num_favorites") + 1});
        }
      })
    }
  }
})