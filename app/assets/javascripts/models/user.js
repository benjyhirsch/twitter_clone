TwitterClone.Models.User = Backbone.Model.extend({
  urlRoot: 'api/users',

  parse: function (data) {

    if (data.tweets) {
      tweetModels = _(data.tweets).map(function (tweetAttrs) {
        return new TwitterClone.Models.Tweet(tweetAttrs, {parse: true});
      });

      if (this.tweets) {
        this.tweets.set(tweetModels);
      } else {
        this.tweets = new TwitterClone.Collections.Tweets(tweetModels);
      }
      delete data.tweets;
    }

    if (data.followers) {
      followerModels = _(data.followers).map(function (followerAttrs) {
        return new TwitterClone.Models.Tweet(followerAttrs, {parse: true});
      });

      if (this.followers) {
        this.followers.set(followerModels);
      } else {
        this.followers = new TwitterClone.Collections.Users(followerModels);
      }
      delete data.followers;
    }

    if (data.followees) {
      followeeModels = _(data.followees).map(function (followeeAttrs) {
        return new TwitterClone.Models.Tweet(followeeAttrs, {parse: true});
      });

      if (this.followees) {
        this.followees.set(followeeModels);
      } else {
        this.followees = new TwitterClone.Collections.Users(followeeModels);
      }
      delete data.followees;
    }

    return data;
  }
});
