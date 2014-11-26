class CreateMaterialTechniques < ActiveRecord::Migration
  def change
    create_table :material_techniques do |t|
      t.text :name
      t.timestamps
    end
  end
end
