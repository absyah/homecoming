module PayloadParser
  class PayloadError < StandardError; end

  class << self
    def permitted_params(json)
      if json.key?(:reservation_code)
        Payloads::V1Payload::PARAMS
      elsif json.key?(:reservation)
        Payloads::V2Payload::PARAMS
      else
        raise PayloadError, "Unregistered payload format"
      end
    end
  end
end
