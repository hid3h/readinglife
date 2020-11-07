class BookSearcherRakuten
  ENDPOINT = 'https://app.rakuten.co.jp/services/api/BooksBook/Search/20170404'

  class << self
    def fetch_from_isbn(isbn:)
      params = base_params.merge({
        isbn: isbn
      })
      fetch(params)
    end

    def fetch_from_title(title:)
      params = base_params.merge({
        title: title.encode(Encoding::UTF_8)
      })
      fetch(params)
    end

    private

    def base_params
      {
        applicationId: application_id,
        formatVersion: 2
      }
    end

    def fetch(params)
      uri = URI(ENDPOINT)
      uri.query = params.to_param
      p "uri_.to_s", uri.to_s
      JSON.parse(Net::HTTP.get(URI.parse(uri.to_s)))
    end

    def application_id
      ENV['RAKUTEN_APPLICATION_ID'] || Rails.application.credentials.rakuten[:application_id]
    end
  end
end