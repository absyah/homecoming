require 'rails_helper'

RSpec.describe 'Reservations', type: :request do
  describe 'POST /api/v1/reservations' do
    it 'returns http 200' do
      post '/api/v1/reservations'

      expect(response).to have_http_status(:success)
    end
  end
end
