class LineEvent
  attr_reader :text

  def initialize(events:)
    event = events[0]
    @text = event['message']['text']
  end

  def excute
    p "text", text
  end
end
