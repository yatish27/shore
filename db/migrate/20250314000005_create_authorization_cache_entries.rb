class CreateAuthorizationCacheEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_cache_entries do |t|
      t.string :namespace, null: false
      t.string :object_id, null: false
      t.string :relation, null: false
      t.string :subject_type, null: false
      t.string :subject_id, null: false
      t.string :subject_relation
      t.boolean :result, null: false
      t.jsonb :caveat_expression
      t.datetime :expires_at, null: false

      t.timestamps

      t.index [ :namespace, :object_id, :relation, :subject_type, :subject_id, :subject_relation ],
              name: 'idx_check_cache_lookup'
      t.index :expires_at, name: 'idx_cache_expiration'
    end
  end
end
