module Payload
  class BaseParser
    class PayloadError < StandardError; end

    attr_reader :payload

    def initialize(permitted_params)
      @payload = permitted_params
    end

    def build
      if v1_parser?
        Payload::V1Parser.new(payload)
      elsif v2_parser?
        Payload::V2Parser.new(payload)
      else
        raise PayloadError, "Unregistered payload format"
      end
    end

    private

    def v1_parser?
      self.class.v1_parser? payload
    end

    def v2_parser?
      self.class.v2_parser? payload
    end

    class << self
      def permitted_params(payload)
        if v1_parser?(payload)
          Payload::V1Parser::PERMITTED_PARAMS
        elsif v2_parser?(payload)
          Payload::V2Parser::PERMITTED_PARAMS
        else
          raise PayloadError, "Unregistered payload format"
        end
      end

      def v1_parser?(payload)
        payload.key?(:reservation_code)
      end

      def v2_parser?(payload)
        payload.key?(:reservation)
      end
    end
  end
end
