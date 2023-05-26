module Api
  module V1
    class ReservationsController < Api::BaseController
      # curl -X POST http://localhost:3000/api/v1/reservations
      def create_or_update
        reservation_book = ReservationBookService.new(permitted_params).call
        json_response(reservation_book)
      end

      private

      def permitted_params
        params.permit Payload::BaseParser.permitted_params(params)
      end
    end
  end
end
