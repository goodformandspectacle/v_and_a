class CreateTechniqueThings < ActiveRecord::Migration
  def change
    create_table :technique_things do |t|
      t.integer :technique_id
      t.integer :thing_id
      t.timestamps
    end
    add_index :technique_things, :technique_id
    add_index :technique_things, :thing_id
  end
end
