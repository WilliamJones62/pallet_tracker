class ChangePrimaryDockDataTypeToLocmsrts < ActiveRecord::Migration[5.1]
  def change
    change_column :locmsrts, :primary_dock, :string
  end
end
