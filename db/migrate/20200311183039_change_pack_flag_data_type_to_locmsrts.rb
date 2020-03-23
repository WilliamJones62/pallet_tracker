class ChangePackFlagDataTypeToLocmsrts < ActiveRecord::Migration[5.1]
  def change
    change_column :locmsrts, :pack_flag, :string
  end
end
