class GuestService
  attr_reader :guest, :guest_params

  def initialize(guest_params)
    @guest_params = guest_params
  end

  def call
    guest.assign_attributes(guest_params)
    guest.save
    guest
  end

  private

  def guest
    @guest ||= Guest.find_or_initialize_by(email: guest_params[:email])
  end
end
