class BookingSeatFlight < ApplicationRecord
  belongs_to :seat
  belongs_to :booking
  belongs_to :flight, optional: true
end
