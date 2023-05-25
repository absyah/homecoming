class Guest < ApplicationRecord
  include GuestValidation

  has_many :reservations, dependent: :nullify
end
