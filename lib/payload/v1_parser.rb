module Payload
  class V1Parser < BaseParser
    PERMITTED_PARAMS = [
      :reservation_code,
      :start_date,
      :end_date,
      :nights,
      :guests,
      :adults,
      :children,
      :infants,
      :status,
      {
        guest:  [
          :first_name,
          :last_name,
          :phone,
          :email
        ]
      },
      :currency,
      :payout_price,
      :security_price,
      :total_price
    ].freeze

    def reservation_params
      {}.tap do |hash|
        hash[:reservation_code] = payload[:reservation_code]
        hash[:start_date]       = payload[:start_date]
        hash[:end_date]         = payload[:end_date]
        hash[:nights]           = payload[:nights]
        hash[:guests]           = payload[:guests]
        hash[:adults]           = payload[:adults]
        hash[:children]         = payload[:children]
        hash[:infants]          = payload[:infants]
        hash[:localized_description] = '' # does not exist
        hash[:status]           = payload[:status]
        hash[:currency]         = payload[:currency]
        hash[:payout_price]     = payload[:payout_price]
        hash[:security_price]   = payload[:security_price]
        hash[:total_price]      = payload[:total_price]
      end
    end

    def guest_params
      guest_payload = payload[:guest]

      {}.tap do |hash|
        hash[:first_name]    = guest_payload[:first_name]
        hash[:last_name]     = guest_payload[:last_name]
        hash[:phone_numbers] = guest_payload[:phone]
        hash[:email]         = guest_payload[:email]
      end
    end
  end
end
