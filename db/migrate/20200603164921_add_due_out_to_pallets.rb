class AddDueOutToPallets < ActiveRecord::Migration[5.1]
  def change
    add_column :pallets, :due_out, :date
  end
end
