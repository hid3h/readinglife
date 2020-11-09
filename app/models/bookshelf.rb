class Bookshelf < ApplicationRecord
  belongs_to :user

  enum status: [:read, :reading, :want]

end
