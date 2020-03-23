class CreatePallets < ActiveRecord::Migration[5.1]
  def change
    create_table :pallets do |t|
      t.string :origin_cc
      t.string :destination_cc
      t.string :current_location
      t.string :next_location
      t.string :vendor_code
      t.integer :number_of_pallets

      t.timestamps
    end
  end
end
