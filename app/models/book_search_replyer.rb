class BookSearchReplyer
  def initialize(line_event:)
    @line_event = line_event
  end

  def executable?
    # TODO
    true
  end

  def execute
    books = BookSearcher.new(text: @line_event.text).fetch
    if books.empty?
      message_hash = {
        type: 'text',
        text: "見つかりませんでした。キーワードを変えるか、ISBNでの検索をお試しください。"
      }
    else
      ret_books = Book.create_by_rakuten_search_result(books)
      message_hash = make_template_message(ret_books)
    end
    res = line_bot_client.reply_message(
      reply_token: @line_event.reply_token,
      message: message_hash
    )
    p "message_hash", message_hash
    p "res", res.body
  end

  private

  def make_template_message(books)
    # 最大10個しかかえせない
    books = books.slice(0, 9)
    # TODO 登録ずみだったら既に登録してますって出したい。

    columns = books.map.with_index do |book, index|
      actions = [
        {
            type: "postback",
            label: "読んだ",
            data: "action=read&book_id=#{book.id}"
        },
        {
            type: "uri",
            label: "楽天リンク",
            uri: book.book_links.first.url # rakutneしかない
        }
      ]

      {
        thumbnailImageUrl: book.image_url,
        imageBackgroundColor: "#FFFFFF", # デフォルト
        # title: item["title"], # 任意
        text: book.title[0, 60], # 必須
        # defaultAction: {
        #   type: "uri",
        #   label: "View detail",
        #   uri: "http://example.com/page/123"
        # },
        actions: actions
      }
    end

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
