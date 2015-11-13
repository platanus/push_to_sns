describe PushToSNS::SendPushNotification do
  let(:device) do
    double(source: "ios", token: "TOKEN", endpoint: "endpoint", save_endpoint: true)
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
  let(:client) { double }
  let(:send_command) { described_class.new(device, configuration) }
  let(:publish_result) do
    { message_id: "message_id" }
  end
  let(:attributes_result) do
    {
      attributes: {
        "Enabled" => "true",
        "Token" => device.token
      }
    }
  end
  let(:set_endpoint_attributes_result) do
    { endpoint_arn: device.endpoint }
  end

  before do
    allow(aws).to receive_message_chain(:sns, :client).and_return(client)

    allow(client).to receive(:get_endpoint_attributes).and_return(attributes_result)
    allow(client).to receive(:set_endpoint_attributes).and_return(set_endpoint_attributes_result)
    allow(client).to receive(:publish).and_return(publish_result)

    stub_const("AWS", aws)
  end

  describe "#perform" do
    it "checks if the device is enabled" do
      send_command.perform({})
      expect(client).to have_received(:get_endpoint_attributes).with(endpoint_arn: device.endpoint)
    end

    it "enables the device if it's not enabled" do
      attributes_result[:attributes]["Enabled"] = "False"
      send_command.perform({})
      expect(client).to have_received(:set_endpoint_attributes).with(
        endpoint_arn: device.endpoint,
        attributes: { "Enabled" => "True", "Token" => device.token }
      )
    end

    it "enables the device if it's the same token" do
      attributes_result[:attributes]["Token"] = "othertoken"
      send_command.perform({})
      expect(client).to have_received(:set_endpoint_attributes).with(
        endpoint_arn: device.endpoint,
        attributes: { "Enabled" => "True", "Token" => device.token }
      )
    end

    it "publishes the message on ios" do
      allow(device).to receive(:source).and_return("ios")
      send_command.perform(message: "Message")
      expect(client).to have_received(:publish).with(
        message_structure: "json",
        message: {
          "APNS" => {
            aps: { alert: "Message", message: "Message" }
          }.to_json
        }.to_json,
        target_arn: device.endpoint,
      )
    end

    it "publishes the message on android" do
      allow(device).to receive(:source).and_return("android")
      send_command.perform(message: "Message")
      expect(client).to have_received(:publish).with(
        message_structure: "json",
        message: {
          "GCM" => {
            data: { message: "Message" }
          }.to_json
        }.to_json,
        target_arn: device.endpoint,
      )
    end
  end
end
