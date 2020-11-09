class Bookshelf < ApplicationRecord
  belongs_to :user
  belongs_to :book

  enum status: [:read, :reading, :want]

  scope :by_user, ->(user) { where(user: user) }
  scope :in_latest_add_order, -> { order(created_at: :desc) }

  class << self
    def add_read(user:, book_id:)
      add(user: user, book_id: book_id, status: statuses[:read])
    end

    private

    def add(user:, book_id:, status:)
      shelf = find_by(
        user: user,
        book_id: book_id
      )
      return true if shelf

      create(
        user: user,
        book_id: book_id,
        status: status
      )
    end
  end

end
