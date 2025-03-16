class CreateProjects < ActiveRecord::Migration[8.0]
  def change
    create_table :projects do |t|
      t.string :name, null: false
      t.references :team, foreign_key: true
      t.decimal :budget, precision: 10, scale: 2, default: 0.0

      t.timestamps
    end
  end
end
