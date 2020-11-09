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
    read_shelfs = Bookshelf.read.by_user(user).in_latest_add_order.limit(10)
    
    if read_shelfs.empty?
      message_hash = {
        type: 'text',
        text: "読んだ本はありません。"
      }
    else
      message_hash = make_template_message(read_shelfs)
    end
    res = line_bot_client.reply_message(
      reply_token: @line_event.reply_token,
      message: message_hash
    )
    p "res", res
  end

  private

  def make_template_message(read_shelfs)
    # 最大10個しかかえせない
    columns = read_shelfs.map.with_index { |read_shelf, index|
      book = read_shelf.book
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
              label: "削除",
              data: "action=delete&bookshelf_id=#{read_shelf.id}"
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
