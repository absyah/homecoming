# spec/services/reservation_service_spec.rb
require 'rails_helper'

RSpec.describe ReservationService do
  describe '#call' do
    let(:reservation) { FactoryBot.create(:reservation, reservation_code: 'YYY12345678') }
    let(:reservation_params) do
      {
        reservation_code: 'YYY12345678',
        start_date: '2021-04-14',
        end_date: '2021-04-18',
        nights: 4,
        guests: 4,
        adults: 2,
        children: 2,
        infants: 0,
        status: 'accepted'
      }
    end

    subject { described_class.new(reservation, reservation_params) }

    context 'when the reservation already exists' do
      it 'updates the existing reservation attributes' do
        subject.call
        reservation.reload
        expect(reservation.start_date).to eq(Date.parse('2021-04-14'))
        expect(reservation.end_date).to eq(Date.parse('2021-04-18'))
        expect(reservation.nights).to eq(4)
        expect(reservation.guests).to eq(4)
        expect(reservation.adults).to eq(2)
        expect(reservation.children).to eq(2)
        expect(reservation.infants).to eq(0)
        expect(reservation.status).to eq('accepted')
      end

      it 'returns the existing reservation' do
        expect(subject.call).to eq(reservation)
      end
    end

    context 'when the reservation does not exist' do
      let(:reservation) { Reservation.new }

      it 'returns the new reservation' do
        expect(subject.call).to be_an_instance_of(Reservation)
      end

      it 'assigns the reservation attributes correctly' do
        new_reservation = subject.call
        expect(new_reservation.start_date).to eq(Date.parse('2021-04-14'))
        expect(new_reservation.end_date).to eq(Date.parse('2021-04-18'))
        expect(new_reservation.nights).to eq(4)
        expect(new_reservation.guests).to eq(4)
        expect(new_reservation.adults).to eq(2)
        expect(new_reservation.children).to eq(2)
        expect(new_reservation.infants).to eq(0)
        expect(new_reservation.status).to eq('accepted')
      end
    end
  end
end
