describe PushToSNS::PushNotifier do
  let(:notifier) { Class.new(described_class) }
  let(:device1) { double(name: "device1") }
  let(:device2) { double(name: "device2") }

  before do
    d1 = device1
    d2 = device2
    notifier.send(:define_method, :devices) { [d1, d2] }
    notifier.send(:define_method, :notification) { |device| { name: device.name } }
  end

  describe "#deliver" do
    let(:send_notification) { double }

    before do
      allow(PushToSNS::SendPushNotification).to receive(:new).and_return(send_notification)
      allow(send_notification).to receive(:perform)
    end

    it "send notifications to all devices" do
      notifier.new.deliver
      expect(send_notification).to have_received(:perform).exactly(2).times
    end

    it "allows to specify type and message" do
      notifier.type { self.class.superclass.name }
      notifier.message "message"
      notifier.send(:define_method, :notification) { |device| { name: "device" } }

      notifier.new.deliver

      expect(send_notification).to have_received(:perform).with(
        type: "PushToSNS::PushNotifier",
        message: "message",
        name: "device"
      ).exactly(2).times
    end
  end
end
