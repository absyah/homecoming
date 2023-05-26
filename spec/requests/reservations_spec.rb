require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :request do
  describe 'POST /api/v1/reservations' do
    context 'with valid payload' do
      context 'v1 payload' do
        let(:valid_v1_payload) do
          {
            "reservation_code": "YYY12345678",
            "start_date": "2021-04-14",
            "end_date": "2021-04-18",
            "nights": 4,
            "guests": 4,
            "adults": 2,
            "children": 2,
            "infants": 0,
            "status": "accepted",
            "guest": {
              "first_name": "Wayne",
              "last_name": "Woodbridge",
              "phone": "639123456789",
              "email": "wayne_woodbridge@bnb.com"
            },
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
        end

        let(:valid_v1_payload_updated) do
          {
            "reservation_code": "YYY12345678",
            "start_date": "2021-04-14",
            "end_date": "2021-04-18",
            "nights": 4,
            "guests": 4,
            "adults": 2,
            "children": 2,
            "infants": 0,
            "status": "rejected",
            "guest": {
              "first_name": "Wayne",
              "last_name": "Woodbridge",
              "phone": "639123456789",
              "email": "wayne_woodbridge@bnb.com"
            },
            "currency": "AUD",
            "payout_price": "4200.00",
            "security_price": "500",
            "total_price": "4700.00"
          }
        end

        it 'creates a new reservation with V1 payload' do
          post '/api/v1/reservations', params: valid_v1_payload
  
          expect(response).to have_http_status(:ok)
          reservation_book = JSON.parse(response.body)
          expect(reservation_book).to include('reservation_code')
          expect(reservation_book['reservation_code']).to eq('YYY12345678')
        end

        it 'duplicates reservation with V1 payload' do
          existing_reservation = FactoryBot.create(:reservation, reservation_code: 'YYY12345678')

          post '/api/v1/reservations', params: valid_v1_payload

          expect(response).to have_http_status(:unprocessable_entity)
          reservation_book = JSON.parse(response.body)
          expect(reservation_book).to include('message')
          expect(reservation_book['message']).to eq("[\"Reservation code has already been taken\"]")
        end

        it 'updates an existing reservation with V1 payload' do
          existing_guest = FactoryBot.create(:guest, email: 'wayne_woodbridge@bnb.com')
          existing_reservation = FactoryBot.create(:reservation, reservation_code: 'YYY12345678', guest: existing_guest)

          post '/api/v1/reservations', params: valid_v1_payload_updated

          expect(response).to have_http_status(:ok)
          reservation_book = JSON.parse(response.body)
          expect(reservation_book).to include('reservation_code')
          expect(reservation_book['reservation_code']).to eq('YYY12345678')
          expect(reservation_book['id']).to eq(existing_reservation.id)
          expect(reservation_book['status']).to eq('rejected')
        end
      end

      context 'v2 payload' do
        let(:valid_v2_payload) do
          {
            "reservation": {
              "code": "XXX12345678",
              "start_date": "2021-03-12",
              "end_date": "2021-03-16",
              "expected_payout_amount": "3800.00",
              "guest_details": {
                "localized_description": "4 guests",
                "number_of_adults": 2,
                "number_of_children": 2,
                "number_of_infants": 0
              },
              "guest_email": "wayne_woodbridge@bnb.com",
              "guest_first_name": "Wayne",
              "guest_last_name": "Woodbridge",
              "guest_phone_numbers": [
                "639123456789",
                "639123456789"
              ],
              "listing_security_price_accurate": "500.00",
              "host_currency": "AUD",
              "nights": 4,
              "number_of_guests": 4,
              "status_type": "accepted",
              "total_paid_amount_accurate": "4300.00"
            }
          }
        end

        let(:valid_v2_payload_updated) do
          {
            "reservation": {
              "code": "XXX12345678",
              "start_date": "2021-03-12",
              "end_date": "2021-03-16",
              "expected_payout_amount": "3800.00",
              "guest_details": {
                "localized_description": "4 guests",
                "number_of_adults": 2,
                "number_of_children": 2,
                "number_of_infants": 0
              },
              "guest_email": "wayne_woodbridge@bnb.com",
              "guest_first_name": "Wayne",
              "guest_last_name": "Woodbridge",
              "guest_phone_numbers": [
                "639123456789",
                "639123456789"
              ],
              "listing_security_price_accurate": "500.00",
              "host_currency": "AUD",
              "nights": 4,
              "number_of_guests": 4,
              "status_type": "rejected",
              "total_paid_amount_accurate": "4300.00"
            }
          }
        end

        it 'creates a new reservation with V2 payload' do
          post '/api/v1/reservations', params: valid_v2_payload

          expect(response).to have_http_status(:ok)
          reservation_book = JSON.parse(response.body)
          expect(reservation_book).to include('reservation_code')
          expect(reservation_book['reservation_code']).to eq('XXX12345678')
        end

        it 'duplicates reservation with V2 payload' do
          existing_reservation = FactoryBot.create(:reservation, reservation_code: 'XXX12345678')

          post '/api/v1/reservations', params: valid_v2_payload

          expect(response).to have_http_status(:unprocessable_entity)
          reservation_book = JSON.parse(response.body)
          expect(reservation_book).to include('message')
          expect(reservation_book['message']).to eq("[\"Reservation code has already been taken\"]")
        end

        it 'updates an existing reservation with V2 payload' do
          existing_guest = FactoryBot.create(:guest, email: 'wayne_woodbridge@bnb.com')
          existing_reservation = FactoryBot.create(:reservation, reservation_code: 'XXX12345678', guest: existing_guest)

          post '/api/v1/reservations', params: valid_v2_payload_updated

          expect(response).to have_http_status(:ok)
          reservation_book = JSON.parse(response.body)
          expect(reservation_book).to include('reservation_code')
          expect(reservation_book['reservation_code']).to eq('XXX12345678')
          expect(reservation_book['id']).to eq(existing_reservation.id)
          expect(reservation_book['status']).to eq('rejected')
        end
      end
    end

    context 'with invalid payload' do
      let(:invalid_payload) do
        {
          # Invalid payload with missing required keys
          "start_date": "2021-04-14",
          "end_date": "2021-04-18"
        }
      end

      it 'returns an error for invalid payload' do
        post '/api/v1/reservations', params: invalid_payload

        expect(response).to have_http_status(:bad_request)
        error_response = JSON.parse(response.body)
        expect(error_response).to include('message')
        expect(error_response['message']).to eq('Unregistered payload format')
      end
    end
  end
end
