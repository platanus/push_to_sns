describe PushToSNS::Configuration do
  let(:config) { described_class.new }

  PushToSNS::Configuration::PROC_PROPERTIES.each do |method_name|
    it "stores the block inside a property with the name #{method_name}" do
      block = Proc.new { }
      config.public_send(method_name, &block)
      expect(config.public_send(:"#{method_name}_proc")).to eq(block)
    end

    it "can execute the block on demand" do
      device = "device"
      block = Proc.new { |device| device }
      config.public_send(method_name, &block)
      expect(config.apply(method_name, device)).to eq(device)
    end
  end
end
