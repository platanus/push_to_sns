module PushToSNS
  class SetupPushNotification
    def initialize(device, configuration = PushToSNS.configuration)
      self.device = device
      self.configuration = configuration
    end

    def perform
      configuration.apply(:save_endpoint_arn, device, create_endpoint_arn)
    end

    private

    attr_accessor :device, :configuration

    def create_endpoint_arn
      AWS.sns.client.create_platform_endpoint({
        platform_application_arn: configuration.apply(:read_platform_arn, device),
        token: configuration.apply(:read_device_token, device)
      })[:endpoint_arn]
    end
  end
end
