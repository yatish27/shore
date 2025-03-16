class CreateGranityExamples < ActiveRecord::Migration[7.0]
  def change
    create_table :granity_examples do |t|
      t.string :name, null: false
      t.text :description
      t.boolean :active, default: true

      t.timestamps
    end

    add_index :granity_examples, :name
  end
end
