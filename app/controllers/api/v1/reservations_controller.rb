module Api
  module V1
    class ReservationsController < Api::BaseController
      # curl -X POST http://localhost:3000/api/v1/reservations
      def create_or_update
        render json: { ping: 'pong' }
      end
    end
  end
end
