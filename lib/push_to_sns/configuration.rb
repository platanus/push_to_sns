module PushToSNS
  class Configuration
    PROC_PROPERTIES = %i(
      read_device_token
      read_source
      read_endpoint_arn
      read_platform_arn
      read_ios_apns
      save_endpoint_arn
    )

    PushToSNS::Configuration::PROC_PROPERTIES.each do |method_name|
      attr_accessor :"#{method_name}_proc"

      define_method(method_name) do |&block|
        public_send(:"#{method_name}_proc=", block)
      end
    end

    def apply(proc_property, *arguments)
      public_send(:"#{proc_property}_proc").call(*arguments)
    end
  end
end
