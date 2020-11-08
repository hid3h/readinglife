class CreateBookLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :book_links do |t|
      t.references :book, foreign_key: true, null: false
      t.integer :site, null: false
      t.string :url, null: false

      t.datetime :created_at, null: false, default: -> { 'NOW()' }
      t.datetime :updated_at, null: false, default: -> { 'NOW()' }
    end
  end
end
