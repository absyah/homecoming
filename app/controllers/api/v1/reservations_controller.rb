module Api
  module V1
    class ReservationsController < Api::BaseController
      # curl -X POST http://localhost:3000/api/v1/reservations
      def create_or_update
        reservation_book = ReservationBookService.new(params).call
        json_response(reservation_book.as_json(include: { guest: {} }))
      end
    end
  end
end
