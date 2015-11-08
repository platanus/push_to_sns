module PushToSNS
  class AndroidPushNotification < BasicPushNotification
    DEFAULT_MESSAGE = "Android Push Notification"

    def message
      { GCM: { data: default_payload.deeper_merge(payload) }.to_json }
    end

    private

    def default_payload
      {
        message: payload[:message] || DEFAULT_MESSAGE
      }
    end
  end
end
