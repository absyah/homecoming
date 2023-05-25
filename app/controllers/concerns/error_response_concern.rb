module ErrorResponseConcern
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordInvalid do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ReservationBookService::MissingGuest do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end

    rescue_from ReservationBookService::MissingReservation do |e|
      json_response({ message: e.message }, :unprocessable_entity)
    end
  end
end
