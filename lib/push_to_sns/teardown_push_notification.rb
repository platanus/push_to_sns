module PushToSNS
  class TeardownPushNotification
    def initialize(device, configuration = PushToSNS.configuration)
      self.device = device
      self.configuration = configuration
    end

    def perform
      endpoint = configuration.apply(:read_endpoint_arn, device)
      AWS.sns.client.delete_endpoint(endpoint_arn: endpoint) if endpoint
    end

    private

    attr_accessor :device, :configuration
  end
end
