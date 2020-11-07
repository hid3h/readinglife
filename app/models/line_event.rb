class LineEvent
  attr_reader :text, :reply_token

  include LineClient

  def initialize(events:)
    event = events[0]
    @text = event['message']['text']
    @reply_token = event['replyToken']
  end

  def excute
    book_searcher = BookSearcher.new(text: text)
    book = book_searcher.fetch_from_isbn
    p "book", book
    items = book['Items']
    item = items[0]['Item']


    # {
    #   "type": "template",
    #   "altText": "this is a carousel template",
    #   "template": {
    #       "type": "carousel",
    #       "columns": [

    title = item['title']
    image = item['largeImageUrl']
    p "cehl", title, image
    message_hash = {
      type: 'template',
      altText: "this is a carousel template",
      template: {
        type: "carousel",
        columns: [
            {
              thumbnailImageUrl: item['largeImageUrl'],
              imageBackgroundColor: "#FFFFFF",
              title: item['title'],
              text: "description",
              defaultAction: {
                  type: "uri",
                  label: "View detail",
                  uri: "http://example.com/page/123"
              },
              actions: [
                  {
                      type: "postback",
                      label: "Buy",
                      data: "action=buy&itemid=111"
                  },
                  {
                      type: "postback",
                      label: "Add to cart",
                      data: "action=add&itemid=111"
                  },
                  {
                      type: "uri",
                      label: "View detail",
                      uri: "http://example.com/page/111"
                  }
              ]
            },
            {
              thumbnailImageUrl: "https://example.com/bot/images/item2.jpg",
              imageBackgroundColor: "#000000",
              title: "this is menu",
              text: "description",
              defaultAction: {
                  type: "uri",
                  label: "View detail",
                  uri: "http://example.com/page/222"
              },
              actions: [
                  {
                      type: "postback",
                      label: "Buy",
                      data: "action=buy&itemid=222"
                  },
                  {
                      type: "postback",
                      label: "Add to cart",
                      data: "action=add&itemid=222"
                  },
                  {
                      type: "uri",
                      label: "View detail",
                      uri: "http://example.com/page/222"
                  }
              ]
            }
        ],
        imageAspectRatio: "square",
        imageSize: "contain"
    }
    }
    # message_hash = {
    #   type: 'text',
    #   text: '固定'
    # }
    p "hash", message_hash
    response = reply_message(
      reply_token: reply_token,
      message: message_hash
    )
    p "response", response
  end
end
