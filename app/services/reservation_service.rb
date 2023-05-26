class ReservationService
  attr_reader :reservation, :reservation_params

  def initialize(reservation, reservation_params)
    @reservation = reservation
    @reservation_params = reservation_params
  end

  def call
    reservation.assign_attributes(reservation_params)
    reservation.save
    reservation
  end
end
