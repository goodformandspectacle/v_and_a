class CreatePlaceThings < ActiveRecord::Migration
  def change
    create_table :place_things do |t|
      t.integer :place_id
      t.integer :thing_id
      t.timestamps
    end

    add_index :place_things, :place_id
    add_index :place_things, :thing_id
  end
end
