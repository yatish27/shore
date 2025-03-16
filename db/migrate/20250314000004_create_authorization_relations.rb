class CreateAuthorizationRelations < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_relations do |t|
      t.references :authorization_namespace, null: false, foreign_key: true
      t.string :name, null: false
      t.string :type_name, null: false, default: "relation" # relation or permission
      t.jsonb :definition, null: false

      t.timestamps

      t.index [ :authorization_namespace_id, :name ], unique: true, name: 'idx_namespace_relation'
    end
  end
end
