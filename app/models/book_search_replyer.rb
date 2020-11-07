class BookSearchReplyer
  def initialize(line_event:)
    @line_event = line_event
  end

  def executable?
    # TODO
    true
  end

  def execute
    # TODO
    message_hash = {
      type: 'text',
      text: "テスト返してます"
    }

    res = line_bot_client.reply_message(
      reply_token: @line_event.reply_token,
      message: message_hash
    )
    p "res", res
  end

  private

  # TODO privateメソッドで生やすよりいい置き場所ありそうな気がします
  def line_bot_client
    @line_bot_client ||= LineBotClient.new
  end
end
