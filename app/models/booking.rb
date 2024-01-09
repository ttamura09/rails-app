class Booking < ApplicationRecord
  belongs_to :flight
  belongs_to :customer

  has_many :booking_seat_flights
  has_many :seats, through: :booking_seat_flights

  attr_accessor :number_of_passengers

  validates :total_price, presence: true

  validates :passenger1_name, presence: true
  validates :passenger1_birthday, presence: true, comparison: { less_than: Time.current.to_date }
  validates :passenger1_email, presence: true, email: { allow_blank: true }
  validates :passenger1_telephone_number, presence: true

  validates :passenger2_name, presence: true, if: -> { number_of_passengers.to_i >= 2 }
  validates :passenger2_birthday, presence: true, comparison: { less_than: Time.current.to_date }, if: -> { number_of_passengers.to_i >= 2 }
  validates :passenger2_email, presence: true, email: { allow_blank: true }, if: -> { number_of_passengers.to_i >= 2 }
  validates :passenger2_telephone_number, presence: true, if: -> { number_of_passengers.to_i >= 2 }

  validates :passenger3_name, presence: true, if: -> { number_of_passengers.to_i >= 3 }
  validates :passenger3_birthday, presence: true, comparison: { less_than: Time.current.to_date }, if: -> { number_of_passengers.to_i >= 3 }
  validates :passenger3_email, presence: true, email: { allow_blank: true }, if: -> { number_of_passengers.to_i >= 3 }
  validates :passenger3_telephone_number, presence: true, if: -> { number_of_passengers.to_i >= 3 }

  validates :payment_method, presence: true

  validate do
    seat_ids.each do |seat_id|
      next unless BookingSeatFlight.exists?(seat_id: seat_id, flight_id: flight_id)
      errors.add(:base, "Seat #{Seat.find(seat_id).number} is already booked for flight #{Flight.find(flight_id).name}.")
    end
  end
end
