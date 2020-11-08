class BookLink < ApplicationRecord
  belongs_to :book

  enum site: [:rakuten]
end
