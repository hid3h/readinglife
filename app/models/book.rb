class Book < ApplicationRecord
  has_many :book_links

  class << self
    def create_by_rakuten_search_result(books)
      isbn_list = books.map { |book| book['isbn'] }
      exist_book_isbn_list = Book.where(isbn: isbn_list).pluck(:isbn)
      p "existed_book_isbn_list", exist_book_isbn_list

      new_isbn_list = isbn_list - exist_book_isbn_list

      new_isbn_list.each do |isbn|
        book = books.find { |b| b['isbn'] == isbn }
        result = create(
          isbn:           book['isbn'],
          title:          book['title'],
          image_url:      book['largeImageUrl'],
          author:         book['author'],
          caption:        book['itemCaption'],
          publisher_name: book['publisherName']
        )

        result.book_links.create(
          site: BookLink.sites[:rakuten],
          url:  book['itemUrl']
        )
      end

      Book.where(isbn: isbn_list).includes(:book_links)
    end
  end
end
