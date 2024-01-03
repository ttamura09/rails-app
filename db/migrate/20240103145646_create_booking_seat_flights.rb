class CreateBookingSeatFlights < ActiveRecord::Migration[7.0]
  def change
    create_table :booking_seat_flights do |t|
      t.references :booking
      t.references :seat
      t.references :flight
      t.boolean :checkin, null: false, default: false # チェックイン状態(true: チェックイン済み, false, 未チェックイン)

      t.timestamps
    end
  end
end
