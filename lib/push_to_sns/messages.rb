module PushToSNS
  module Messages
    def self.not_implemented_config(method_name, &message)
      "Not Implemented Configuration `#{method_name.to_s}`: #{message.call}"
    end

    def self.not_implemented_method(method_name, &message)
      "Not Implemented Method `#{method_name.to_s}`: #{message.call}"
    end

    READ_DEVICE_ID_NOT_IMPLEMENTED = not_implemented_config(:read_device_id) do
      "How to read the device's id from a device object?"
    end

    READ_SOURCE_NOT_IMPLEMENTED = not_implemented_config(:read_source) do
      "How to read the device's source (ios or android) from a device object?"
    end

    READ_ENDPOINT_ARN_NOT_IMPLEMENTED = not_implemented_config(:read_endpoint_arn) do
      "How to read the device's endpoint arn that was saved while registering?"
    end

    READ_PLATFORM_ARN_NOT_IMPLEMENTED = not_implemented_config(:read_platform_arn) do
      "How to read platform ARN that should be configured in AWS?"
    end

    READ_IOS_APNS_NOT_IMPLEMENTED = not_implemented_config(:read_ios_apns) do
      "How to read the IOS's wrapper object (APNS or APNS_SANDBOX)?"
    end

    SAVE_ENDPOINT_ARN_NOT_IMPLEMENTED = not_implemented_config(:save_endpoint_arn) do
      "How to save the endpoint_arn in the device?"
    end

    DEVICES_METHOD_NOT_IMPLEMENTED = not_implemented_method(:devices) do
      "What devices are going to be notified?"
    end

    NOTIFICATION_METHOD_NOT_IMPLEMENTED = not_implemented_method(:notification) do
      "What payload should we send to this specific device?"
    end
  end
end
