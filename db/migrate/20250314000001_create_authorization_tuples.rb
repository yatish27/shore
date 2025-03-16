class CreateAuthorizationTuples < ActiveRecord::Migration[8.0]
  def change
    create_table :authorization_tuples do |t|
      t.string :namespace, null: false
      t.string :object_id, null: false
      t.string :relation, null: false
      t.string :subject_type, null: false
      t.string :subject_id, null: false
      t.string :subject_relation

      # Caveat and expiration support
      t.jsonb :caveat_context, default: {}
      t.string :caveat_name
      t.datetime :expires_at

      t.timestamps

      # Indexes for efficient lookups
      t.index [ :namespace, :object_id, :relation ], name: 'idx_resource_lookup'
      t.index [ :subject_type, :subject_id ], name: 'idx_subject_lookup'
      t.index [ :namespace, :object_id, :relation, :subject_type, :subject_id ],
              name: 'idx_permission_check'
      t.index :expires_at, where: "expires_at IS NOT NULL", name: 'idx_expiration'
    end
  end
end
