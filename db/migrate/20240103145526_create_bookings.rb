class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :customer
      t.references :flight
      t.references :booking_seat_flight
      t.integer :total_price, null: false

      t.string :passenger1_name, null: false
      t.date :passenger1_birthday, null: false
      t.string :passenger1_email, null: false
      t.string :passenger1_telephone_number, null: false

      t.string :passenger2_name
      t.date :passenger2_birthday
      t.string :passenger2_email
      t.string :passenger2_telephone_number

      t.string :passenger3_name
      t.date :passenger3_birthday
      t.string :passenger3_email
      t.string :passenger3_telephone_number

      t.string :payment_method, null: false

      t.timestamps
    end
  end
end