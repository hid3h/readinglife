class LineEvent
  attr_reader :text, :reply_token, :type, :line_user_id, :postback_data

  def initialize(events:)
    event = events[0]
    @type = event['type']
    @text = event['message'] ? event['message']['text'] : nil
    @reply_token = event['replyToken']
    @line_user_id = event['source']['userId']
    @postback_data = event['postback'] ? event['postback']['data'] : nil
  end
end
