module Payload
  class V2Parser < BaseParser
    attr_reader :payload

    PERMITTED_PARAMS = {
      reservation: [
        :code,
        :start_date,
        :end_date,
        :expected_payout_amount,
        {
          guest_details: [
            :localized_description,
            :number_of_adults,
            :number_of_children,
            :number_of_infants
          ]
        },
        :guest_email,
        :guest_first_name,
        :guest_last_name,
        {
          guest_phone_numbers: []
        },
        :listing_security_price_accurate,
        :host_currency,
        :nights,
        :number_of_guests,
        :status_type,
        :total_paid_amount_accurate
      ]
    }.freeze

    def reservation_params
      {}.tap do |hash|
        hash[:reservation_code] = reservation_payload[:code]
        hash[:start_date]       = reservation_payload[:start_date]
        hash[:end_date]         = reservation_payload[:end_date]
        hash[:nights]           = reservation_payload[:nights]
        hash[:guests]           = reservation_payload[:number_of_guests]
        hash[:adults]           = reservation_payload.dig(:guest_details, :number_of_adults)
        hash[:children]         = reservation_payload.dig(:guest_details, :number_of_children)
        hash[:infants]          = reservation_payload.dig(:guest_details, :number_of_infants)
        hash[:localized_description] = reservation_payload.dig(:guest_details, :localized_description)
        hash[:status]           = reservation_payload[:status_type]
        hash[:currency]         = reservation_payload[:host_currency]
        hash[:payout_price]     = reservation_payload[:expected_payout_amount]
        hash[:security_price]   = reservation_payload[:listing_security_price_accurate]
        hash[:total_price]      = reservation_payload[:total_paid_amount_accurate]
      end
    end

    def guest_params
      {}.tap do |hash|
        hash[:first_name]    = reservation_payload[:guest_first_name]
        hash[:last_name]     = reservation_payload[:guest_last_name]
        hash[:phone_numbers] = (reservation_payload[:guest_phone_numbers] || []).join(', ')
        hash[:email]         = reservation_payload[:guest_email]
      end
    end

    private

    def reservation_payload
      @reservation_payload ||= payload[:reservation]
    end
  end
end
