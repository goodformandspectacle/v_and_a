class CreateMaterialThings < ActiveRecord::Migration
  def change
    create_table :material_things do |t|
      t.integer :material_id
      t.integer :thing_id
      t.timestamps
    end
    add_index :material_things, :material_id
    add_index :material_things, :thing_id
  end
end
