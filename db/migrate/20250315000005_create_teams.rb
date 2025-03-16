class CreateTeams < ActiveRecord::Migration[8.0]
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.references :organization, foreign_key: true
      t.boolean :members_can_assign_tasks, default: false

      t.timestamps
    end
  end
end
