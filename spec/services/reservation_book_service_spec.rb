require 'rails_helper'

RSpec.describe ReservationBookService do
  describe '#call' do
    let(:reservation_params_v1) do
      {:reservation_code=>"YYY12345678",
      :start_date=>"2021-04-14",
      :end_date=>"2021-04-18",
      :nights=>4,
      :guests=>4,
      :adults=>2,
      :children=>2,
      :infants=>0,
      :status=>"accepted",
      :guest=>{:first_name=>"Wayne", :last_name=>"Woodbridge", :phone=>"639123456789", :email=>"wayne_woodbridge@bnb.com"},
      :currency=>"AUD",
      :payout_price=>"4200.00",
      :security_price=>"500",
      :total_price=>"4700.00"}
    end

    let(:reservation_params_v2) do
      {:reservation=>
  {:code=>"XXX12345678",
   :start_date=>"2021-03-12",
   :end_date=>"2021-03-16",
   :expected_payout_amount=>"3800.00",
   :guest_details=>{:localized_description=>"4 guests", :number_of_adults=>2, :number_of_children=>2, :number_of_infants=>0},
   :guest_email=>"wayne_woodbridge@bnb.com",
   :guest_first_name=>"Wayne",
   :guest_last_name=>"Woodbridge",
   :guest_phone_numbers=>["639123456789", "639123456789"],
   :listing_security_price_accurate=>"500.00",
   :host_currency=>"AUD",
   :nights=>4,
   :number_of_guests=>4,
   :status_type=>"accepted",
   :total_paid_amount_accurate=>"4300.00"}}
    end

    context 'when given a v1 payload' do
      let(:booking_params) { reservation_params_v1 }

      it 'creates or updates the guest' do
        expect { described_class.new(booking_params).call }.to change(Guest, :count).by(1)
      end

      it 'creates or updates the reservation' do
        expect { described_class.new(booking_params).call }.to change(Reservation, :count).by(1)
      end

      it 'returns the reservation JSON' do
        json_result = described_class.new(booking_params).call
        expect(json_result).to include('reservation_code' => 'YYY12345678')
        expect(json_result['guest']).to include('email' => 'wayne_woodbridge@bnb.com')
      end

      it 'raises an error if there are guest validation errors' do
        reservation_params_v1[:guest][:email] = nil
        booking_params = reservation_params_v1
        expect { described_class.new(booking_params).call }.to raise_error(ReservationBookService::MissingGuest)
      end

      it 'raises an error if there are reservation validation errors' do
        reservation_params_v1[:reservation_code] = nil
        booking_params = reservation_params_v1
        expect { described_class.new(booking_params).call }.to raise_error(ReservationBookService::MissingReservation)
      end
    end

    context 'when given a v2 payload' do
      let(:booking_params) { reservation_params_v2 }

      it 'creates or updates the guest' do
        expect { described_class.new(booking_params).call }.to change(Guest, :count).by(1)
      end

      it 'creates or updates the reservation' do
        expect { described_class.new(booking_params).call }.to change(Reservation, :count).by(1)
      end

      it 'returns the reservation JSON' do
        json_result = described_class.new(booking_params).call
        expect(json_result).to include('reservation_code' => 'XXX12345678')
        expect(json_result['guest']).to include('email' => 'wayne_woodbridge@bnb.com')
      end

      it 'raises an error if there are guest validation errors' do
        reservation_params_v2[:reservation][:guest_email] = nil
        booking_params = reservation_params_v2
        expect { described_class.new(booking_params).call }.to raise_error(ReservationBookService::MissingGuest)
      end

      it 'raises an error if there are reservation validation errors' do
        reservation_params_v2[:reservation][:code] = nil
        booking_params = reservation_params_v2
        expect { described_class.new(booking_params).call }.to raise_error(ReservationBookService::MissingReservation)
      end
    end
  end
end
