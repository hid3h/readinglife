class BookshelfReplyer
  def initialize(line_event:)
    @line_event = line_event
  end

  def executable?
    @line_event.text == ':読んだ本'
  end

  def execute
    # ユーザー取得
    user = User.find_or_create_by_line_user_id(line_user_id: @line_event.line_user_id)
    read_shelfs = Bookshelf.includes(book: :book_links).read.by_user(user).in_latest_add_order.limit(10)
    
    # 月ごとのカウント
    labels = %w(1月 2月 3月 4月 5月 6月 7月 8月 9月 10月 11月 12月)
    data = [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1110, 0]
    g = GruffCreater.new(labels: labels, data: data)
      
    filename = g.create
    host = Rails.env.production? ? "https://noahstudio-search.com" : "http://127.0.0.1:2000"
    image_url = host + filename

    message_hash = {
      type: "image",
      originalContentUrl: image_url,
      previewImageUrl: image_url
    }
  
    # if read_shelfs.empty?
    #   message_hash = {
    #     type: 'text',
    #     text: "読んだ本はありません。"
    #   }
    # else
    #   message_hash = make_template_message(read_shelfs)
    # end
    res = line_bot_client.reply_message(
      reply_token: @line_event.reply_token,
      message: message_hash
    )
    p "res", res.body
  end

  private

  def make_template_message(read_shelfs)
    # 最大10個しかかえせない.10こあったら10コメは次へみたいな。
    columns = read_shelfs.map.with_index do |read_shelf, index|
      book = read_shelf.book

      label_delete = "削除"
      data         = "action=delete&bookshelf_id=#{read_shelf.id}"
      label_link   = "楽天リンク"
      uri          = book.book_links.first.url # rakutneしかない

      actions = [
        {
            type: "postback",
            label: label_delete,
            data: data
        },
        {
            type: "uri",
            label: label_link,
            uri: uri
        }
      ]

      if index == 9
        actions = [
          {
              type: "postback",
              label: "次の9件を見る",
              data: "action=next&bookshelf_id=#{read_shelf.id}"
          },
          {
            type: "postback",
            label: " ",
            data: " "
          }
        ]
      end

      thumbnail_image_url = book.image_url
      text = book.title

      if index == 9
        thumbnail_image_url = "https://example.com/bot/images/item1.jpg"
        text = " "
      end
      {
        thumbnailImageUrl: thumbnail_image_url,
        imageBackgroundColor: "#FFFFFF", # デフォルト
        # title: item["title"], # 任意
        text: text, # 必須
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
