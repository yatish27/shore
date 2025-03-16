class CreateAuthorizationNamespaces < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_namespaces do |t|
      t.string :name, null: false
      t.jsonb :definition, null: false

      t.timestamps

      t.index :name, unique: true
    end
  end
end
