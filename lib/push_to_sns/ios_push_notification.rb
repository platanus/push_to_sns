module PushToSNS
  class IosPushNotification < BasicPushNotification
    def message
      basic_message = {
        apns => {
          aps: default_payload.merge(payload)
        }.to_json
      }
      basic_message
    end

    def default_payload
      basic_payload = {}
      basic_payload[:title] = payload[:title] if payload[:title]
      basic_payload[:alert] = payload[:message] if payload[:message]
      basic_payload[:badge] = payload[:badge] if payload[:badge]
      basic_payload[:sound] = payload[:sound] if payload[:sound]
      basic_payload
    end

    private

    def apns
      configuration.apply(:read_ios_apns, device).to_sym
    end
  end
end
