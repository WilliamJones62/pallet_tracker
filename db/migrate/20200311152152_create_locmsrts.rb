class CreateLocmsrts < ActiveRecord::Migration[5.1]
  def change
    create_table :locmsrts do |t|
      t.string :cost_ctr
      t.string :location
      t.string :loc_type

      t.timestamps
    end
  end
end
