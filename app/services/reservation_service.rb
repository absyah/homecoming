class ReservationService
  attr_reader :reservation, :reservation_params

  def initialize(reservation_params)
    @reservation_params = reservation_params
  end

  def call
    reservation.assign_attributes(reservation_params)
    reservation.save
    reservation
  end

  private

  def reservation
    @reservation ||= Reservation.find_or_initialize_by(reservation_code: reservation_params[:reservation_code])
  end
end
