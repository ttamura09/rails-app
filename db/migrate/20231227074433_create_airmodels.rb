class CreateAirmodels < ActiveRecord::Migration[7.0]
  def change
    create_table :airmodels do |t|
      t.string :name, null: false
      t.integer :economy_nums, null: false
      t.integer :business_nums, null: false
      t.integer :first_nums, null: false

      t.timestamps
    end
  end
end
