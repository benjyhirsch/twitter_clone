TwitterClone.Models.Tweet = Backbone.Model.extend({
  urlRoot: 'api/tweets',

  parse: function (data) {
    if (data.author) {
      if (this.author)  {
        this.author.set(this.author.parse(data.author))
      } else {
        this.author = new TwitterClone.Models.User(data.author)
      }
      delete data.author
    }

    if (data.ancestors) {
      ancestorModels = _(data.ancestors).map(function (ancestorAttrs) {
        return new TwitterClone.Models.Tweet(ancestorAttrs, {parse: true});
      });

      if (this.ancestors) {
        this.ancestors.set(ancestorModels);
      } else {
        this.ancestors = new TwitterClone.Collections.Tweets(ancestorModels);
      }
      delete data.ancestors;
    }

    if (data.descendants) {
      descendantModels = _(data.descendants).map(function (descendantAttrs) {
        return new TwitterClone.Models.Tweet(descendantAttrs, {parse: true});
      });

      if (this.descendants) {
        this.descendants.set(descendantModels);
      } else {
        this.descendants = new TwitterClone.Collections.Tweets(descendantModels);
      }
      delete data.descendants;
    }

    if (data.conversation_parent) {
      if (this.conversation_parent) {
        this.conversation_parent.set(this.conversation_parent.parse(data.conversation_parent))
      } else {
        this.conversation_parent = new TwitterClone.Models.Tweet(data.conversation_parent, {parse: true});
      }

      delete data.conversation_parent;
    }

    return data;
  },

  initialize: function (attrs, options) {
    if (attrs && attrs["conversation_parent_id"]) {
      if (this.conversation_parent) {
        this.conversation_parent.id = attrs["conversation_parent_id"]
      } else {
        this.conversation_parent = new TwitterClone.Models.Tweet({id: attrs["conversation_parent_id"]});
      }
    }

    if (options && options["conversation_parent"]) {
      this.conversation_parent = options["conversation_parent"];
      this.set({"conversation_parent_id": options["conversation_parent"].id});
    }
  },

  timestamp: function () {
    return new Date(this.get("created_at"));
  }
});