class BookSearcher
  class << self

    def fetch_from_isbn(text:)
      p "text", text
      isbn = text
      json = client.fetch_from_isbn(isbn)
      p "json", json
    end

    private

    def client
      @client ||= GoogleBookSearcher.new
    end
  end
end
