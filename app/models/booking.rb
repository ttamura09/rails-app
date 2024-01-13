class Booking < ApplicationRecord
  belongs_to :flight
  belongs_to :customer

  has_many :booking_seat_flights, dependent: :destroy
  has_many :seats, through: :booking_seat_flights

  accepts_nested_attributes_for :booking_seat_flights

  validates :total_price, presence: true

  validates :payment_method, presence: true

end
