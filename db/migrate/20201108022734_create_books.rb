class CreateBooks < ActiveRecord::Migration[6.0]
  def change
    create_table :books do |t|
      t.string :isbn, null: false, unique: true
      t.string :title, null: false
      t.string :author, null: false
      t.text   :caption
      t.string :publisher_name, null: false
      t.string :image_url, null: false

      t.datetime :created_at, null: false, default: -> { 'NOW()' }
      t.datetime :updated_at, null: false, default: -> { 'NOW()' }
    end
  end
end
