class AddPrimaryDockToLocmsrt < ActiveRecord::Migration[5.1]
  def change
    add_column :locmsrts, :primary_dock, :boolean
  end
end
