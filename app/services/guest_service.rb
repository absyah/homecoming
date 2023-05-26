class GuestService
  attr_reader :guest, :guest_params

  def initialize(guest, guest_params)
    @guest = guest
    @guest_params = guest_params
  end

  def call
    guest.assign_attributes(guest_params)
    guest.save
    guest
  end
end
