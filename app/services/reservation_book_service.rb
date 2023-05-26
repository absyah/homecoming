class ReservationBookService
  class MissingGuest < StandardError; end
  class MissingReservation < StandardError; end

  attr_reader :booking_params

  def initialize(booking_params)
    @booking_params = booking_params
  end

  def call
    ActiveRecord::Base.transaction do
      GuestService.new(guest, guest_params).call
      raise ReservationBookService::MissingGuest, guest.errors.full_messages if guest.errors.any?

      ReservationService.new(reservation, reservation_params).call
      raise ReservationBookService::MissingReservation, reservation.errors.full_messages if reservation.errors.any?

      reservation.as_json(include: { guest: {} })
    end
  end

  private

  def guest_params
    payload_parser.guest_params
  end

  def reservation_params
    payload_parser.reservation_params
  end

  def payload_parser
    @payload_parser ||= Payload::BaseParser.new(booking_params).build
  end

  def guest
    @guest ||= Guest.find_or_initialize_by(email: guest_params[:email])
  end

  def reservation
    @reservation ||= guest.reservations.find_or_initialize_by(reservation_code: reservation_params[:reservation_code])
  end
end
