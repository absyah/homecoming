class ReservationBookService
  class MissingGuest < StandardError; end
  class MissingReservation < StandardError; end

  attr_reader :booking_params

  def initialize(booking_params)
    @booking_params = booking_params
  end

  def call
    ActiveRecord::Base.transaction do
      guest = GuestService.new(guest_params).call
      raise ReservationBookService::MissingGuest, guest.errors.full_messages if guest.errors.any?

      reservation = ReservationService.new(reservation_params).call
      raise ReservationBookService::MissingReservation, reservation.errors.full_messages if reservation.errors.any?

      do_booking!(guest, reservation)
    end
  end

  private

  def guest_params
    payload_parser.guest_params
  end

  def reservation_params
    payload_parser.reservation_params
  end

  def do_booking!(guest, reservation)
    reservation.guest = guest
    reservation.save!
    reservation
  end

  def payload_parser
    @payload_parser ||= Payload::BaseParser.new(booking_params).build
  end
end
