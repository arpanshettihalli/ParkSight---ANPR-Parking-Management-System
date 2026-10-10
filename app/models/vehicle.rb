class Vehicle < ApplicationRecord
    has_many :parking_sessions
    has_many :detections
end
