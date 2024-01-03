class Flight < ApplicationRecord
  belongs_to :airline
  belongs_to :origin, class_name: "Airport"
  belongs_to :destination, class_name: "Airport"
  belongs_to :airmodel

  has_many :bookings
  has_many :booking_seat_flights
end
