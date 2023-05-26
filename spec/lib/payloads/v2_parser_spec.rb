# spec/lib/payload/v2_parser_spec.rb
RSpec.describe Payload::V2Parser do
  let(:payload) do
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

  subject { described_class.new(payload) }

  describe "#reservation_params" do
    it "returns the expected reservation parameters" do
      expected_params = {
        reservation_code: "XXX12345678",
        start_date: "2021-03-12",
        end_date: "2021-03-16",
        nights: 4,
        guests: 4,
        adults: 2,
        children: 2,
        infants: 0,
        localized_description: "4 guests",
        status: "accepted",
        currency: "AUD",
        payout_price: "3800.00",
        security_price: "500.00",
        total_price: "4300.00"
      }

      expect(subject.reservation_params).to eq(expected_params)
    end
  end

  describe "#guest_params" do
    it "returns the expected guest parameters" do
      expected_params = {
        first_name: "Wayne",
        last_name: "Woodbridge",
        phone_numbers: "639123456789, 639123456789",
        email: "wayne_woodbridge@bnb.com"
      }

      expect(subject.guest_params).to eq(expected_params)
    end
  end
end
