describe PushToSNS::SetupPushNotification do
  let(:device) do
    double(source: "ios", uuid: "ID", token: "TOKEN", endpoint: "endpoint", save_endpoint: true)
  end

  let(:configuration) do
    PushToSNS::Configuration.new.tap do |config|
      config.read_device_token { |device| device.token }
      config.read_source { |device| device.source }
      config.read_endpoint_arn { |device| device.endpoint }
      config.read_platform_arn { |device| "PLATFORM_ARN" }
      config.read_ios_apns { |device| "APNS" }

      config.save_endpoint_arn do |device, endpoint_arn|
        device.save_endpoint(endpoint_arn)
      end
    end
  end

  let(:aws) { double }
  let(:setup) { described_class.new(device, configuration) }
  let(:platform_endpoint_result) do
    { endpoint_arn: "endpoint_arn" }
  end

  before do
    allow(aws).to receive_message_chain(
      :sns, :client, :create_platform_endpoint
    ).and_return(platform_endpoint_result)
    stub_const("AWS", aws)
  end

  describe "#perform" do
    it "gets an endpoint_arn from sns" do
      setup.perform
      expect(aws.sns.client).to have_received(:create_platform_endpoint).with(
        platform_application_arn: "PLATFORM_ARN",
        token: device.token
      )
    end

    it "saves the endpoint_arn" do
      setup.perform
      expect(device).to have_received(:save_endpoint).with("endpoint_arn")
    end
  end
end
