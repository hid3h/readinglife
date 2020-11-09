class BookshelfReplyer
  def initialize(line_event:)
    @line_event = line_event
  end

  def executable?
    @line_event.text == ':読んだ本'
  end

  def execute
    # ユーザー取得
    message_hash = {
      type: 'text',
      text: "読んだ本はありません。"
    }
    res = line_bot_client.reply_message(
      reply_token: @line_event.reply_token,
      message: message_hash
    )
    p "res", res
  end

  private

  def make_template_message(books)
    # 最大10個しかかえせない
    books = books.slice(0, 9)
    columns = books.map.with_index { |book, index|
      {
        thumbnailImageUrl: book.image_url,
        imageBackgroundColor: "#FFFFFF", # デフォルト
        # title: item["title"], # 任意
        text: book.title, # 必須
        # defaultAction: {
        #   type: "uri",
        #   label: "View detail",
        #   uri: "http://example.com/page/123"
        # },
        actions: [
          {
              type: "postback",
              label: "読んだ",
              data: "action=read&book_id=#{book.id}"
          },
          {
              type: "postback",
              label: "読みたい",
              data: "action=want_to_read&book_id=#{book.id}"
          },
          {
              type: "uri",
              label: "楽天リンク",
              uri: book.book_links.first.url # rakutneしかない
          }
        ]
      }
    }

    template = {
      type: "carousel",
      imageAspectRatio: "square",
      imageSize: "contain",
      columns: columns
    }
    message_hash = {
      type: 'template',
      altText: "this is a carousel template",
      template: template
    }
  end

  # TODO privateメソッドで生やすよりいい置き場所ありそうな気がします
  def line_bot_client
    @line_bot_client ||= LineBotClient.new
  end
end
