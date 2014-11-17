TwitterClone.Views.ExpandableTweet = Backbone.CompositeView.extend({

  tagName: "section",
  className: "conversation",

  template: JST["tweets/expandable_tweet"],

  events: {
    "click .main-tweet" : "toggleExpansion"
  },

  render: function () {
    this.$el.html(this.template());
    this.updateConversation();
    this.attachSubviews();
    this.updateCorners();
    return this;
  },

  initialize: function (options) {
    var view = this;

    if (options["alwaysExpanded"]) {
      this.alwaysExpanded = true;
      this.$el.addClass("expanded");
    }
    
    this.addSubview(".main-tweet", new TwitterClone.Views.SingleTweet({model: this.model}));
    this.addSubview(".reply-form", new TwitterClone.Views.TweetForm({
      model: new TwitterClone.Models.Tweet({
        content: "@" + this.model.author.escape("username") + " "
      }, {
        conversation_parent: this.model
      })
    }));

    this.listenTo(this.model, "sync change", this.render.bind(this))
  },

  toggleExpansion: function (event) {
    var view = this;
    if (!$(event.target).closest("button, a").length && !this.alwaysExpanded) {
      this.$el.toggleClass("expanded");
      this.model.fetch();
    }
  },

  updateConversation: function () {
    var view = this;

    var ancestors = this.model.ancestors;
    var ancestorViews = _(this.subviews(".ancestors"));
    var latestAncestorTimestamp = ancestorViews.isEmpty() ? -Infinity : ancestorViews.last().model.timestamp();

    if (ancestors) {
      ancestors.each(function (ancestor) {
        if (ancestor.timestamp() > latestAncestorTimestamp) {
          view.addSubview(".ancestors", new TwitterClone.Views.SingleTweet({model: ancestor, secondary: true}))
        }
      })
    }

    var descendants = this.model.descendants;
    var descendantViews = _(this.subviews(".descendants"));
    var latestDescendantTimestamp = descendantViews.isEmpty() ? -Infinity : descendantViews.last().model.timestamp();

    if (descendants) {
      descendants.each(function (descendant) {
        if (descendant.timestamp() > latestDescendantTimestamp) {
          view.addSubview(".descendants", new TwitterClone.Views.SingleTweet({model: descendant, secondary: true}))
        }
      })
    }
  },

  updateCorners: function () {
    this.$(".tweet, .tweet-form").removeClass("top-of-expanded");
    this.$(".tweet, .tweet-form").removeClass("bottom-of-expanded");
    this.$el.prev().find(".main-tweet > .tweet").removeClass("bottom-before-expanded");
    this.$el.next().find(".main-tweet > .tweet").removeClass("top-after-expanded");

    if (this.$el.hasClass("expanded")) {
      this.$(".tweet, .tweet-form").first().addClass("top-of-expanded");
      this.$(".tweet, .tweet-form").last().addClass("bottom-of-expanded");
      this.$el.prev().find(".main-tweet > .tweet").last().addClass("bottom-before-expanded");
      this.$el.next().find(".main-tweet > .tweet").first().addClass("top-after-expanded");
    }
  }
})