class LineEvent
  attr_reader :text, :reply_token

  def initialize(events:)
    event = events[0]
    @text = event['message']['text']
    @reply_token = event['replyToken']
  end
end
