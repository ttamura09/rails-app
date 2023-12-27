class CreateSeats < ActiveRecord::Migration[7.0]
  def change
    create_table :seats do |t|
      t.references :airmodel
      t.string :number, null: false
      t.string :seat_class, null: false
      t.integer :price, null: false

      t.timestamps
    end
  end
end
