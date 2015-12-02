module PushToSNS
  class AndroidPushNotification < BasicPushNotification
    def message
      { GCM: { data: default_payload.deeper_merge(payload) }.to_json }
    end

    private

    def default_payload
      basic_payload = {}
      basic_payload[:title] = payload[:title] if payload[:title]
      basic_payload[:message] = payload[:message] if payload[:message]
      basic_payload[:smallIcon] = payload[:small_icon] if payload[:small_icon]
      basic_payload[:sound] = payload[:sound] if payload[:sound]
      basic_payload[:image] = payload[:image] if payload[:image]
      basic_payload[:notId] = payload[:notification_id] if payload[:notification_id]

      basic_payload
    end
  end
end
