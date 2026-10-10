
class ProcessDetectionJob < ApplicationJob
  queue_as :default

  retry_on StandardError, wait: 2.seconds, attempts: 3

  def perform(plate_number, confidence)
    if plate_number == "RETRYTEST01" && executions < 3
      Rails.logger.warn("Simulated failure: execution #{executions}")
      raise StandardError, "Simulated retry test"
    end

    Parking::ProcessDetection.call(
      plate_number: plate_number,
      confidence: confidence
    )
  end
end
