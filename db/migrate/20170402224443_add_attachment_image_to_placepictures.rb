class AddAttachmentImageToPlacepictures < ActiveRecord::Migration
  def self.up
    change_table :placepictures do |t|
      t.attachment :image
    end
  end

  def self.down
    drop_attached_file :placepictures, :image
  end
end
