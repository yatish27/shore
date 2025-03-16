class CreateAuthorizationCaveats < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_caveats do |t|
      t.string :name, null: false
      t.text :definition, null: false
      t.text :description

      t.timestamps

      t.index :name, unique: true
    end
  end
end
