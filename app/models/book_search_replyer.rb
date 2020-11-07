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

    books = BookSearcher.new(text: @line_event.text).fetch
    if books.empty?
      message_hash = {
        type: 'text',
        text: "見つかりませんでした。キーワードを変えるか、ISBNでの検索をお試しください。"
      }
    else
      message_hash = make_template_message(books)
    end
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
    columns = books.map.with_index { |item, index|
      if index == 9
        next
      end
      {
        thumbnailImageUrl: item['largeImageUrl'],
        imageBackgroundColor: "#FFFFFF", # デフォルト
        # title: item["title"], # 任意
        text: item["title"], # 必須
        # defaultAction: {
        #   type: "uri",
        #   label: "View detail",
        #   uri: "http://example.com/page/123"
        # },
        actions: [
          {
              type: "postback",
              label: "読んだ",
              data: "action=buy&itemid=111"
          },
          {
              type: "postback",
              label: "読みたい",
              data: "action=add&itemid=111"
          },
          {
              type: "postback",
              label: "詳細？",
              data: "action=add&itemid=111"
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
