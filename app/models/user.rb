class User < ApplicationRecord
  has_many :bookshelves

  class << self
    def find_or_create_by_line_user_id(line_user_id:)
      user = find_by(line_user_id: line_user_id)
      return user if user

      User.create(
        line_user_id: line_user_id
      )
    end
  end
end
