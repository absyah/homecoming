require 'rails_helper'

RSpec.describe GuestService do
  describe '#call' do
    let(:guest) { FactoryBot.create(:guest, email: 'john@example.com') }
    let(:guest_params) do
      {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com'
      }
    end

    subject { described_class.new(guest, guest_params) }

    context 'when the guest already exists' do
      it 'updates the existing guest attributes' do
        subject.call
        guest.reload
        expect(guest.first_name).to eq('John')
        expect(guest.last_name).to eq('Doe')
      end

      it 'returns the existing guest' do
        expect(subject.call).to eq(guest)
      end
    end

    context 'when the guest does not exist' do
      let(:guest) { Guest.new }

      it 'returns the new guest' do
        expect(subject.call).to be_an_instance_of(Guest)
      end

      it 'assigns the guest attributes correctly' do
        new_guest = subject.call
        expect(new_guest.first_name).to eq('John')
        expect(new_guest.last_name).to eq('Doe')
        expect(new_guest.email).to eq('john@example.com')
      end
    end
  end
end
