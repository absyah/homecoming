module ReservationValidation
  extend ActiveSupport::Concern

  included do
    validates :reservation_code, presence: true, uniqueness: true
  end
end
