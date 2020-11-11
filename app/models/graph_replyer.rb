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
    p "count_by_monthly", count_by_monthly.fetch(11, 'Not found')
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
    p "res", res
  end

  private

  def book_id
    postback_params['book_id']
  end

  def bookshelf_id
    postback_params['bookshelf_id']
  end

  def action_type
    postback_params['action']
  end

  def postback_params
    Rack::Utils.parse_nested_query(@line_event.postback_data)
  end

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
