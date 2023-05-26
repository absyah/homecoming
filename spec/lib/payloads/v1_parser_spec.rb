require 'rails_helper'

RSpec.describe Payload::V1Parser do
  let(:payload) do
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

  subject { described_class.new(payload) }

  describe "#reservation_params" do
    it "returns the expected reservation parameters" do
      expected_params = {
        reservation_code: "YYY12345678",
        start_date: "2021-04-14",
        end_date: "2021-04-18",
        nights: 4,
        guests: 4,
        adults: 2,
        children: 2,
        infants: 0,
        localized_description: "", # does not exist
        status: "accepted",
        currency: "AUD",
        payout_price: "4200.00",
        security_price: "500",
        total_price: "4700.00"
      }

      expect(subject.reservation_params).to eq(expected_params)
    end
  end

  describe "#guest_params" do
    it "returns the expected guest parameters" do
      expected_params = {
        first_name: "Wayne",
        last_name: "Woodbridge",
        phone_numbers: "639123456789",
        email: "wayne_woodbridge@bnb.com"
      }

      expect(subject.guest_params).to eq(expected_params)
    end
  end
end
