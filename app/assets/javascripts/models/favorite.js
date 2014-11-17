TwitterClone.Models.Favorite = Backbone.Model.extend({
  url: function () {
    return this.baseUrl
  },

  initialize: function (attrs, options) {
    this.baseUrl = "api/tweets/" + options["tweet"].id + "/favorite"
  }
});
