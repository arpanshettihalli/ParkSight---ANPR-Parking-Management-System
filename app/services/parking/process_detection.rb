class Parking::ProcessDetection
  def self.call(plate_number:, confidence:)
    new(
      plate_number: plate_number,
      confidence: confidence
    ).call
  end

  def initialize(plate_number:, confidence:)
    @plate_number = plate_number
    @confidence = confidence
  end

  def call
    vehicle = Vehicle.find_or_create_by!(
      plate_number: @plate_number
    )

    active_session = vehicle.parking_sessions.find_by(status: "active")

    if active_session
      process_exit(vehicle, active_session)
    else
      process_entry(vehicle)
    end
  end

  private

  def process_entry(vehicle)
    session = vehicle.parking_sessions.create!(
      entry_time: Time.current,
      status: "active",
      amount: 0
    )

    detection = session.detections.create!(
      plate_number: @plate_number,
      confidence: @confidence,
      detected_at: Time.current
    )

    AuditLog.create!(
      event_type: "vehicle_entry",
      plate_number: @plate_number,
      details: {
        vehicle_id: vehicle.id,
        parking_session_id: session.id,
        confidence: @confidence
      }
    )

    {
      message: "Vehicle entered",
      event: "entry",
      vehicle_id: vehicle.id,
      parking_session_id: session.id,
      detection_id: detection.id
    }
  end

  def process_exit(vehicle, session)
    exit_time = Time.current

    session.update!(
      exit_time: exit_time,
      status: "completed",
      amount: calculate_amount(session.entry_time, exit_time)
    )

    detection = session.detections.create!(
      plate_number: @plate_number,
      confidence: @confidence,
      detected_at: exit_time
    )

    AuditLog.create!(
      event_type: "vehicle_exit",
      plate_number: @plate_number,
      details: {
        vehicle_id: vehicle.id,
        parking_session_id: session.id,
        confidence: @confidence,
        amount: session.amount
      }
    )

    {
      message: "Vehicle exited",
      event: "exit",
      vehicle_id: vehicle.id,
      parking_session_id: session.id,
      detection_id: detection.id,
      amount: session.amount
    }
  end

  def calculate_amount(entry_time, exit_time)
    duration_hours = ((exit_time - entry_time) / 1.hour).ceil

    [duration_hours * 20, 20].max
  end
end