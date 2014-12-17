class CreateArtistThings < ActiveRecord::Migration
  def change
    create_table :artist_things do |t|
      t.integer :artist_id
      t.integer :thing_id
      t.timestamps
    end

    add_index :artist_things, :artist_id
    add_index :artist_things, :thing_id
  end
end
