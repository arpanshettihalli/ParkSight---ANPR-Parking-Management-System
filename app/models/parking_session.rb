class ParkingSession < ApplicationRecord
  belongs_to :vehicle
  has_many :detections
end
