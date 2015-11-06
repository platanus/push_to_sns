describe PushToSNS do
  describe ".configure" do
    it "yields calls to the configuration object" do
      spy = double(call: true)

      PushToSNS.configure do
        spy.call(self)
      end

      expect(spy).to have_received(:call).with(PushToSNS.configuration)
    end
  end

  describe ".setup_device" do
    let(:device) { "device" }

    it "tells a new SetupPushNotifications object to perform with the device" do
      setup = double
      allow(PushToSNS::SetupPushNotifications).to receive(:new).and_return(setup)
      allow(setup).to receive(:perform)
      PushToSNS.setup_device(device)
      expect(PushToSNS::SetupPushNotifications).to have_received(:new).with(device)
      expect(setup).to have_received(:perform)
    end
  end
end
