class Airport < ApplicationRecord
  has_many :origin, class_name: "Flight", foreign_key: "origin_id"
  has_many :destination, class_name: "Flight", foreign_key: "destination_id"
end