class GoogleBookSearcher
  ENDPOINT = 'https://www.googleapis.com/books/v1/volumes'

  def fetch_from_isbn(isbn)
    url = "#{ENDPOINT}?q=isbn:#{isbn}"
    p "url", url
    fetch(url)
  end

  private
  
  def fetch(url)
    # asciiじゃないとURI::InvalidURIErrorエラー
    JSON.parse(Net::HTTP.get(URI.parse(URI.encode(url))))
  end
end
