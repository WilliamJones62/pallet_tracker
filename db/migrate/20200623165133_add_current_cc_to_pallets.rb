class AddCurrentCcToPallets < ActiveRecord::Migration[5.1]
  def change
    add_column :pallets, :current_cc, :string
  end
end
