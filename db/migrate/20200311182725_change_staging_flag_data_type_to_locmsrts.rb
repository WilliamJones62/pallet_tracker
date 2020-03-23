class ChangeStagingFlagDataTypeToLocmsrts < ActiveRecord::Migration[5.1]
  def change
    change_column :locmsrts, :staging_flag, :string
  end
end
