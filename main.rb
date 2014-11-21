load File.expand_path(File.dirname(__FILE__)) << '/config'

Process.daemon(true)
pid_file = File.open(PID_FILE, "w")
pid_file.write Process.pid
pid_file.close

TweetStream.configure do |config|
  config.consumer_key       = API_KEY
  config.consumer_secret    = API_SECRET
  config.oauth_token        = ACCESS_TOKEN
  config.oauth_token_secret = ACCESS_TOKEN_SECRET
  config.auth_method        = :oauth
end

rest_client = Twitter::REST::Client.new do |config|
  config.consumer_key        = API_KEY
  config.consumer_secret     = API_SECRET
  config.access_token        = ACCESS_TOKEN
  config.access_token_secret = ACCESS_TOKEN_SECRET
end

stream_client = TweetStream::Client.new
stream_client.follow(TARGET_USER) do |status|
  if status.user.id == TARGET_USER && !status.text.index("RT @")
    rest_client.favorite(status.id)
  end
end

