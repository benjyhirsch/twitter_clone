json.partial! 'api/tweets/tweet', tweet: @tweet

json.ancestors do 
  json.partial! 'api/tweets/tweet', collection: @tweet.conversation_ancestors, as: :tweet
end

json.descendants do
  json.partial! 'api/tweets/tweet', collection: @tweet.conversation_descendants, as: :tweet
end

if @tweet.conversation_parent
  json.conversation_parent do
    json.partial! 'api/tweets/tweet', tweet: @tweet.conversation_parent
  end
end