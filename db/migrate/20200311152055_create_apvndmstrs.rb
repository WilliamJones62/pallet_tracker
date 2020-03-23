class CreateApvndmstrs < ActiveRecord::Migration[5.1]
  def change
    create_table :apvndmstrs do |t|
      t.string :vend_code
      t.string :vend_name
      t.string :vend_status

      t.timestamps
    end
  end
end
