class LineEvent
  attr_reader :text, :reply_token, :type, :line_user_id

  def initialize(events:)
    event = events[0]
    @type = event['type']
    @text = event['message'] ? event['message']['text'] : nil
    @reply_token = event['replyToken']
  end
end
