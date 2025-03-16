class CreateDocuments < ActiveRecord::Migration[8.0]
  def change
    create_table :documents do |t|
      t.string :name, null: false
      t.references :folder, foreign_key: true
      t.boolean :comments_enabled, default: true
      t.boolean :archived, default: false

      t.timestamps
    end
  end
end
