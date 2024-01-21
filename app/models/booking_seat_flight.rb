class BookingSeatFlight < ApplicationRecord
  belongs_to :seat, optional: true
  belongs_to :booking
  belongs_to :flight

  validates :passenger_name, presence: true
  validates :passenger_birthday, presence: true, comparison: { less_than: Time.current.to_date }
  validates :passenger_email, presence: true, email: { allow_blank: true }
  validates :passenger_telephone_number, presence: true,
            format: { with: /\A[0-9-()]*\z/, allow_blank: true },
            length: { minimum: 8, maximum: 20, allow_blank: true }

  validate :check_seat, :on => :create

  def check_seat
    return unless BookingSeatFlight.where(seat_id: seat_id, flight_id: flight_id).exists?
    seat_number = Seat.find(seat_id).number
    flight_name = Flight.find(flight_id).name
    errors.add(:base, I18n.t("activerecord.attributes.booking.seat_already_booked", seat_number: seat_number, flight_name: flight_name))
  end
end
