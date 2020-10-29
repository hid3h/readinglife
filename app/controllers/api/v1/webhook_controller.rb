class Api::V1::WebhookController < ApplicationController
  # https://developers.line.biz/ja/reference/messaging-api/#webhooks
  def receive
    return unless validate_sinature
    LineEvent.new(events: params['events']).excute
  end

  def test
    p "channel_secret", channel_secret
    render :json => "test"
  end

  private

  def validate_sinature
    http_request_body = request.raw_post # Request body string
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, channel_secret, http_request_body)
    signature = Base64.strict_encode64(hash)
    # Compare X-Line-Signature request header string and the signature
    signature == request.headers['X-Line-Signature']
  end

  def channel_secret
    ENV["LINE_CHANNEL_SECRET"] || Rails.application.credentials.line[:channel_secret]
  end
end

# {
#   "events"=>[
#     {
#       "type"=>"message",
#       "replyToken"=>"b55dbb48zzzzzz7fzzzzzz",
#       "source"=>{"userId"=>"Uc7zzzzzzzzzzzzzzzz", "type"=>"user"},
#       "timestamp"=>1602378060070,
#       "mode"=>"active",
#       "message"=>{"type"=>"text", "id"=>"112345677", "text"=>"起きた"}
#     }
#   ],
