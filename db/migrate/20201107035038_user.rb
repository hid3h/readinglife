class User < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :line_user_id, null: false

      t.datetime :created_at, null: false, default: -> { 'NOW()' }
      t.datetime :updated_at, null: false, default: -> { 'NOW()' }
    end
    add_index :users, :line_user_id, unique: true
  end
end
