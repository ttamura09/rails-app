class Airline < ApplicationRecord
  has_secure_password

  has_many :flights
end
