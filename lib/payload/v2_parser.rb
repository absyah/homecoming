module Payload
  class V2Parser < BaseParser
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
  end
end
