module Payloads
  module V1Payload
    PARAMS = [
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
  end
end
