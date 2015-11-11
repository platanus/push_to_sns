module PushToSNS
  class AndroidPushNotification < BasicPushNotification
    DEFAULT_MESSAGE = "Android Push Notification"

    def message
      { GCM: { data: default_payload.deeper_merge(payload) }.to_json }
    end

    private

    def default_payload
      basic_message = {
        message: payload[:message] || DEFAULT_MESSAGE
      }
      basic_message[:smallIcon] = payload[:badge] if payload[:badge]
      basic_message[:sound] = payload[:sound] if payload[:sound]

      basic_message
    end
  end
end
