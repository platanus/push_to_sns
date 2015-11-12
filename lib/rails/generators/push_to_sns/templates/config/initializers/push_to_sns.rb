PushToSNS.configure do
  read_device_token { |device| fail PushToSNS::Messages::READ_DEVICE_TOKEN_NOT_IMPLEMENTED }
  read_source { |device| fail PushToSNS::Messages::READ_SOURCE_NOT_IMPLEMENTED }
  read_endpoint_arn { |device| fail PushToSNS::Messages::READ_ENDPOINT_ARN_NOT_IMPLEMENTED }
  read_platform_arn { |device| fail PushToSNS::Messages::READ_PLATFORM_ARN_NOT_IMPLEMENTED }
  read_ios_apns { |device| fail PushToSNS::Messages::READ_IOS_APNS_NOT_IMPLEMENTED }

  save_endpoint_arn do |device, endpoint_arn|
    fail PushToSNS::Messages::SAVE_ENDPOINT_ARN_NOT_IMPLEMENTED
  end
end
