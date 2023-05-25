module Payload
  class BaseParser
    class PayloadError < StandardError; end

    class << self
      def permitted_params(json)
        if json.key?(:reservation_code)
          Payload::V1Parser::PERMITTED_PARAMS
        elsif json.key?(:reservation)
          Payload::V2Parser::PERMITTED_PARAMS
        else
          raise PayloadError, "Unregistered payload format"
        end
      end
    end
  end
end
