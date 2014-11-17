TwitterClone.Views.TweetForm = Backbone.View.extend({

  tagName: "form",
  className: "tweet-form",

  template: JST["tweets/form"],

  initialize: function (options) {
    var tweet = this.model;
    this.initialContent = tweet.escape("content") || "";
    if (options["placeholderText"]) {
      this.placeholderText = options["placeholderText"];
    } else if (tweet.conversation_parent) {
      this.placeholderText = "Reply to @" + parent.author.escape("username");
    } else {
      this.placeholderText = "Compose a tweet..."
    }
  },

  render: function () {
    this.$el.html(this.template({tweet: this.model, placeholderText: this.placeholderText}));
    filepicker.constructWidget(this.$('input[type="filepicker"]')[0])
    return this;
  },

  events: {
    "submit" : "submit",
    "focus textarea" : "focusTextarea",
    "click textarea" : "focusTextarea",
    "input textarea" : "updateCharsRemaining"
  },

  submit: function (event) {
    event.preventDefault();
    var view = this;
    var $form = this.$el;

    params = $form.serializeJSON();
    tweet = new TwitterClone.Models.Tweet(params["tweet"]);

    tweet.save({}, {
      wait: true,
      success: function () {
        view.$("textarea").val(this.initialContent);
        $form.removeClass("active");
      }
    });
  },

  focusTextarea: function (event) {
    var view = this
    var $textarea = $(event.currentTarget);
    var $form = this.$el;
    var unfocusTextarea = function (otherEvent) {
      if ( (!$form[0].isEqualNode($(otherEvent.target).closest("form")[0]) ) && ($textarea.val() === view.initialContent) ) {
        console.log("hi")
        $textarea.val("");
        $form.removeClass("active");
        $(document).off("click", unfocusTextarea);
      }
    }
    $textarea.val($textarea.val() || this.initialContent);

    if (!$form.hasClass("active")) {
      $form.addClass("active");
      $(document).on("click", unfocusTextarea);
    }
  },

  updateCharsRemaining: function (event) {
    var $textarea = $(event.currentTarget);
    var $charsRemainingTag = this.$(".chars-remaining");
    var charsRemaining = 140 - $textarea.val().length;
    $charsRemainingTag.html(charsRemaining);
    if (charsRemaining < 10) {
      $charsRemainingTag.addClass("chars-remaining-warning")
    } else {
      $charsRemainingTag.removeClass("chars-remaining-warning")
    }
  }
})