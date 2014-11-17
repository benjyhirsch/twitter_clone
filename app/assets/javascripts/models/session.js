TwitterClone.Models.Session = Backbone.Model.extend({
  url: 'api/session',

  parse: function (data) {
    if (data.user) {
      if (this.user) {  
        this.user.set(data.user)
      } else {
        this.user = new TwitterClone.Models.User(data.user, {parse: true});
      }
      delete data.user
    }

    return data;
  }
});