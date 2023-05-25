class Reservation < ApplicationRecord
  include ReservationValidation

  belongs_to :guest, optional: true
end
