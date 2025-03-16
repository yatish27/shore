class CreateOrganizations < ActiveRecord::Migration[8.0]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.boolean :public, default: false

      t.timestamps
    end
  end
end
