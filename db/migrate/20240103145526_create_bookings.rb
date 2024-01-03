class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.references :customer
      t.references :flight
      t.references :booking_seat_flight
      t.integer :total_price, null: false

      t.timestamps
    end
  end
end