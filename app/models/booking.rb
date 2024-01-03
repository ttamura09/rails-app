class Booking < ApplicationRecord
  belongs_to :flight
  belongs_to :customer

  has_many :booking_seat_flights
  has_many :seats, through: :booking_seat_flights
end
