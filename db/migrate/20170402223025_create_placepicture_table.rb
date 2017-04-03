class CreatePlacepictureTable < ActiveRecord::Migration
  def change
    create_table :placepictures do |t|
      t.string :description
      t.string :image
      t.integer :place_id

      t.timestamps
    end
  end
end
