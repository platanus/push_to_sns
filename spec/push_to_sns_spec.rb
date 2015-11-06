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
end
