class CreateMaterialTechniqueThings < ActiveRecord::Migration
  def change
    create_table :material_technique_things do |t|
      t.integer :material_technique_id
      t.integer :thing_id
      t.timestamps
    end

    add_index :material_technique_things, :material_technique_id
    add_index :material_technique_things, :thing_id
  end
end
