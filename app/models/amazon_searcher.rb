class AmazonSearcher
  class << self
  
    def from_isbn(text)
      p "@client", client
      si = client.search_items(keywords: 'Harry Potter')
      p "si", si
    end

    def client
      @client ||= Paapi::Client.new(market: :jp)
    end
  end
end
