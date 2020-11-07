class BookSearcher
  attr_reader :text

  include RakutenBookSearchable

  def initialize(text:)
    @text = text
  end

  def isbn
    # TODO textからisbnをいい感じにフォーマット
    text.delete("^0-9")
  end
end
