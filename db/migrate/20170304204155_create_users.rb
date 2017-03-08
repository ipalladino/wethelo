class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :address
      t.string :original_ip

      t.timestamps
    end
  end
end
