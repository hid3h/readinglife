class GraphReplyer
  def initialize(line_event:)
    @line_event = line_event
  end

  def executable?
    @line_event.text == ':グラフ'
  end

  def execute
    user = User.find_or_create_by_line_user_id(line_user_id: @line_event.line_user_id)

    # 月ごとのカウント
    # TODO 年対応
    count_by_monthly = user.bookshelves.read.group("MONTH(created_at)").count
    labels = %w(1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月)
    data = labels.map do |m|
      i = m.delete('月').to_i
      count_by_monthly.fetch(i, 0)
    end
    g = GruffCreater.new(labels: labels, data: data)
      
    filename = g.create
    host = Rails.env.production? ? "https://noahstudio-search.com" : "http://127.0.0.1:2000"
    image_url = host + filename

    message_hash = {
      type: "image",
      originalContentUrl: image_url,
      previewImageUrl: image_url
    }

    res = line_bot_client.reply_message(
      reply_token: @line_event.reply_token,
      message: message_hash
    )
    p "res", res.body
    p "message_hash", message_hash
  end

  # TODO privateメソッドで生やすよりいい置き場所ありそうな気がします
  def line_bot_client
    @line_bot_client ||= LineBotClient.new
  end
end
