class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.text :name
      t.timestamps
    end
  end
end
