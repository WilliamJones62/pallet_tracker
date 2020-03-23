class AddBuyerCodeToApvndmstr < ActiveRecord::Migration[5.1]
  def change
    add_column :apvndmstrs, :buyer_code, :string
  end
end
