require 'rails_helper'

RSpec.describe GuestService do
  describe '#call' do
    let(:guest_params) do
      {
        first_name: 'John',
        last_name: 'Doe',
        email: 'john@example.com'
      }
    end

    subject { described_class.new(guest_params) }

    context 'when the guest already exists' do
      let!(:existing_guest) { FactoryBot.create(:guest, email: 'john@example.com') }

      it 'does not create a new guest' do
        expect { subject.call }.not_to change(Guest, :count)
      end

      it 'updates the existing guest attributes' do
        subject.call
        existing_guest.reload
        expect(existing_guest.first_name).to eq('John')
        expect(existing_guest.last_name).to eq('Doe')
      end

      it 'returns the existing guest' do
        expect(subject.call).to eq(existing_guest)
      end
    end

    context 'when the guest does not exist' do
      it 'creates a new guest' do
        expect { subject.call }.to change(Guest, :count).by(1)
      end

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
