module PushToSNS
  class BasicPushNotification
    def initialize(device, payload = {}, configuration = PushToSNS.configuration)
      self.device = device
      self.payload = payload
      self.configuration = configuration
    end

    private

    attr_accessor :device, :payload, :configuration
  end
end
