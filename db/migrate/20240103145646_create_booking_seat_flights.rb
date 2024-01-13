class CreateBookingSeatFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_seat_flights do |t|
      t.references :booking
      t.references :seat
      t.references :flight
      t.boolean :checkin, null: false, default: false # チェックイン状態(true: チェックイン済み, false, 未チェックイン)

      t.string :passenger_name, null: false
      t.date :passenger_birthday, null: false
      t.string :passenger_telephone_number, null: false
      t.string :passenger_email, null: false

      t.timestamps
    end
  end
end
