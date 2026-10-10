class Api::V1::DetectionsController < ApplicationController
  def create
    ProcessDetectionJob.perform_later(
      params[:plate_number],
      params[:confidence]
    )

    render json: {
      message: "Detection queued",
      plate_number: params[:plate_number]
    }, status: :accepted
  end
end