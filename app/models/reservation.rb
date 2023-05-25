class Reservation < ApplicationRecord
  include ReservationValidation

  belongs_to :guest
end
