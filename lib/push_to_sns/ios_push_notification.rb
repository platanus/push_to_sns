module PushToSNS
  class IosPushNotification < BasicPushNotification
    DEFAULT_MESSAGE = "IOS Push Notification"

    def message
      basic_message = {
        apns => {
          aps: {
            alert: payload[:message] || DEFAULT_MESSAGE
          }.merge(payload)
        }
      }
      basic_message[apns][:aps][:badge] = payload[:badge] if payload[:badge]
      basic_message[apns][:aps][:sound] = payload[:sound] if payload[:sound]
      basic_message[apns] = basic_message[apns].to_json
      basic_message
    end

    private

    def apns
      configuration.apply(:read_ios_apns, device).to_sym
    end
  end
end
