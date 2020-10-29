class LineEvent
  attr_reader :text

  def initialize(events:)
    event = events[0]
    @text = event['message']['text']
  end

  def excute
    # amazonから商品情報取得
    AmazonSearcher.from_isbn(text: text)
  end
end
