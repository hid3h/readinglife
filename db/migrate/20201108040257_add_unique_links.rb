class AddUniqueLinks < ActiveRecord::Migration[6.0]
  def change
    add_index :book_links, [:book_id, :site], unique: true
  end
end
