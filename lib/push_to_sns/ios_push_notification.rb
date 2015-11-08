module PushToSNS
  class IosPushNotification < BasicPushNotification
    DEFAULT_MESSAGE = "IOS Push Notification"

    def message
      {
        apns => {
          aps: { alert: payload[:message] || DEFAULT_MESSAGE },
          data: payload
        }.to_json
      }
    end

    private

    def apns
      configuration.apply(:read_ios_apns, device).to_sym
    end
  end
end
