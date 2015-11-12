module PushToSNS
  class SendPushNotification
    def initialize(device, configuration = PushToSNS.configuration)
      self.device = device
      self.configuration = configuration
    end

    def perform(payload)
      ensure_endpoint_arn_is_enabled
      notification = build_push_notification(payload)

      response = AWS.sns.client.publish(
        message_structure: "json",
        message: notification.message.to_json,
        target_arn: configuration.apply(:read_endpoint_arn, device)
      )

      response[:message_id]
    rescue AWS::SNS::Errors::EndpointDisabled => _exception
      perform(payload)
    end

    private

    attr_accessor :device, :configuration

    def build_push_notification(payload)
      case configuration.apply(:read_source, device)
      when "ios"
        IosPushNotification.new(device, payload, configuration)
      when "android"
        AndroidPushNotification.new(device, payload, configuration)
      end
    end

    def ensure_endpoint_arn_is_enabled
      attributes = get_endpoint_attributes

      if attributes["Enabled"].downcase == "false" || attributes["Token"] != device_token
        enable_endpoint_arn
      end
    end

    def get_endpoint_attributes
      AWS.sns.client.get_endpoint_attributes(
        endpoint_arn: endpoint_arn
      )[:attributes]
    end

    def enable_endpoint_arn
      AWS.sns.client.set_endpoint_attributes(
        endpoint_arn: endpoint_arn,
        attributes: {
          "Enabled" => "True",
          "Token" => device_token
        }
      )[:endpoint_arn]
    end

    def device_token
      @device_token ||= configuration.apply(:read_device_token, device)
    end

    def endpoint_arn
      @endpoint_arn ||= configuration.apply(:read_endpoint_arn, device)
    end
  end
end
