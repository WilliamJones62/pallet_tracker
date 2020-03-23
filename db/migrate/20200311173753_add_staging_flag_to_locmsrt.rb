class AddStagingFlagToLocmsrt < ActiveRecord::Migration[5.1]
  def change
    add_column :locmsrts, :staging_flag, :boolean
  end
end
