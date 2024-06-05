class CreatePosts < ActiveRecord::Migration[7.1]
  def change
    create_table :posts, id: :uuid do |t|
      t.string :title, null: false
      t.string :summary
      t.text :content
      t.datetime :published_at
      t.timestamps
    end
  end
end
