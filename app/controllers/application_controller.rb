class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound do |e|
    render json: { description: "No receipt found for that ID." }, status: :not_found
  end

  # render json: { error: e.message }, status: :bad_request
  rescue_from ActionController::ParameterMissing do |e|
    render json: { description: "The receipt is invalid." }, status: :bad_request
  end
end
