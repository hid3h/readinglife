class BookSearcher
  attr_reader :text

  # include RakutenBookSearchable

  def initialize(text:)
    @text = text
  end

  def fetch
    # 楽天で探す
    # isbnならisbnで
    if isbn
      p "isbn検索するよ"
      return BookSearcherRakuten.fetch_from_isbn(isbn: isbn)["Items"]
    end
    BookSearcherRakuten.fetch_from_title(title: text)["Items"]
  end

  def isbn
    isbn = text.delete("^0-9")
    number_length = isbn.length
    return isbn if number_length == 13
    # 楽天は13桁での検索のみ対応
    nil
  end
end
