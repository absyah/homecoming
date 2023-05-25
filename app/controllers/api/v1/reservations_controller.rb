module Api
  module V1
    class ReservationsController < Api::BaseController
      # curl -X POST http://localhost:3000/api/v1/reservations
      def create_or_update
        reservation_book = ReservationBookService.new(permit_params).call
        json_response(reservation_book.as_json(include: { guest: {} }))
      end

      private

      def permit_params
        params.permit PayloadParser.permitted_params(params)
      end
    end
  end
end
