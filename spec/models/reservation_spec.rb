require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:reservation_code) }
    it { should validate_uniqueness_of(:reservation_code) }
  end
end
