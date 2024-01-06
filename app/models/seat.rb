class Seat < ApplicationRecord
  belongs_to :airmodel

  has_many :booking_seat_flights
  has_many :bookings, through: :booking_seat_flights
  # has_many :flights, through: :booking_seat_flights
end
