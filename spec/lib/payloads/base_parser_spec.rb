require 'rails_helper'

RSpec.describe Payload::BaseParser do
  describe ".permitted_params" do
    context "when given a v1 Payload" do
      let(:json) do
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

      it "returns the permitted parameters for V1Parser" do
        expect(described_class.permitted_params(json)).to eq(Payload::V1Parser::PERMITTED_PARAMS)
      end
    end

    context "when given a v2 payload" do
      let(:json) do
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

      it "returns the permitted parameters for V2Parser" do
        expect(described_class.permitted_params(json)).to eq(Payload::V2Parser::PERMITTED_PARAMS)
      end
    end

    context "when given an unknown payload format" do
      let(:json) { {} }

      it "raises a PayloadError" do
        expect { described_class.permitted_params(json) }
          .to raise_error(Payload::BaseParser::PayloadError, "Unregistered payload format")
      end
    end
  end

  describe "#build" do
    context "when using V1Parser" do
      let(:json) do
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

      it "returns an instance of V1Parser" do
        parser = described_class.new(json).build
        expect(parser).to be_a(Payload::V1Parser)
      end
    end

    context "when using V2Parser" do
      let(:json) do
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

      it "returns an instance of V2Parser" do
        parser = described_class.new(json).build
        expect(parser).to be_a(Payload::V2Parser)
      end
    end

    context "when using an unknown JSON format" do
      let(:json) { {} }

      it "raises a PayloadError" do
        expect { described_class.new(json).build }
          .to raise_error(Payload::BaseParser::PayloadError, "Unregistered payload format")
      end
    end
  end
end
