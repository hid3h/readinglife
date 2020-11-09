class AddUniqueUserBook < ActiveRecord::Migration[6.0]
  def change
    add_index :bookshelves, [:user_id, :book_id], unique: true
  end
end
