module RakutenBookSearchable
  # https://webservice.rakuten.co.jp/api/bookstotalsearch/

  # https://app.rakuten.co.jp/services/api/BooksTotal/Search/20170404?
  #       applicationId=[アプリID]
  #       &keyword=%E6%9C%AC
  #       &NGKeyword=%E4%BA%88%E7%B4%84
  #       &sort=%2BitemPrice
  ENDPOINT = 'https://app.rakuten.co.jp/services/api/BooksTotal/Search/20170404'

  def fetch_from_isbn
    puts 'Hello2'
    params = {
      applicationId: application_id,
      isbnjan: isbn
    }
    json = fetch(params)
    json
  end

  private
  
  def fetch(params)
    uri = URI(ENDPOINT)
    uri.query = params.to_param
    p "uri_.to_s", uri.to_s
    JSON.parse(Net::HTTP.get(URI.parse(URI.encode(uri.to_s))))
  end

  def application_id
    ENV['RAKUTEN_APPLICATION_ID'] || Rails.application.credentials.line[:channel_secret]
  end
end
