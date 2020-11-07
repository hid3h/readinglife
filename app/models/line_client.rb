module LineClient
  def fetch_profile(user_id)
    response = client.get_profile(user_id)
    JSON.parse(response.body)
  end

  def reply_message(reply_token:, message:)
    client.reply_message(reply_token, message)
  end

  private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = channel_secret
      config.channel_token  = channel_token
    }
  end

  def channel_secret
    ENV["LINE_CHANNEL_SECRET"] || Rails.application.credentials.line[:channel_secret]
  end

  def channel_token
    ENV["LINE_CHANNEL_TOKEN"] || Rails.application.credentials.line[:channel_token]
  end
end
