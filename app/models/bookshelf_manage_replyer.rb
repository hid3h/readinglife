class BookshelfManageReplyer
  def initialize(line_event:)
    @line_event = line_event
  end

  def executable?
    @line_event.postback_data
  end

  def execute
    user = User.find_or_create_by_line_user_id(line_user_id: @line_event.line_user_id)
    
    # TODO ここcaseで分けるのはリファクタリングできそう？
    case action_type
    when "read"
      read_shelf = Bookshelf.add_read(user: user, book_id: book_id)
      # TODO 既存か新しく追加の判別ってできる？
      if read_shelf == true
        message_hash = {
          type: 'text',
          text: "既に追加されています"
        }
      else
        message_hash = {
          type: 'text',
          text: "#{read_shelf.book.title[0, 60]}を追加しました"
        }
      end
    when "delete"
      result = Bookshelf.find_by(id: bookshelf_id)
      if result
        book_title = result.book.title
        result.delete
        message_hash = {
          type: 'text',
          text: "#{book_title[0, 60]}を削除しました"
        }
      else
        message_hash = {
          type: 'text',
          text: "既に削除されています"
        }
      end
    end
    p "book_id", action_type, book_id, read_shelf

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
