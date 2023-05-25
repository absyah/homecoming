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
    { email: "ardian@gmail.com" }
  end

  def reservation_params
    { reservation_code: "ABCDEF", status: 'accepted' }
  end

  def do_booking!(guest, reservation)
    reservation.guest = guest
    reservation.save!
    reservation
  end
end
