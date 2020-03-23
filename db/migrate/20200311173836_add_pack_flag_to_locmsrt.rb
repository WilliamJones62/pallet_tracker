class AddPackFlagToLocmsrt < ActiveRecord::Migration[5.1]
  def change
    add_column :locmsrts, :pack_flag, :boolean
  end
end
