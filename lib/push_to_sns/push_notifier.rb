module PushToSNS
  class PushNotifier
    def initialize(params = {})
      params.each do |attr, value|
        public_send("#{attr}=", value)
      end
    end

    def deliver
      devices.each do |device|
        SendPushNotification.new(device).perform(full_notification_for_device(device))
      end
    end

    def devices
      raise "Please implement the method :devices to be able to load devices to notify."
    end

    def notification(device)
      raise "Please implement the method :notification with the message to send"
    end

    private

    def full_notification_for_device(device)
      defaults = {
        type: call_or_read(type, device),
        message: call_or_read(message, device),
        badge: call_or_read(badge, device),
        sound: call_or_read(sound, device)
      }.reject { |key, value| value.nil? }
      defaults.merge(notification(device))
    end

    def type
      @type ||= self.class.type
    end

    def message
      @message ||= self.class.message
    end

    def badge
      @badge ||= self.class.badge
    end

    def sound
      @sound ||= self.class.sound
    end

    private

    def call_or_read(proc_or_object, *arguments)
      if proc_or_object.respond_to?(:call)
        proc_or_object.call(*arguments)
      else
        proc_or_object
      end
    end

    class << self
      [:type, :message, :badge, :sound].each do |method_name|
        property_name = "input_#{method_name}".to_sym
        attr_accessor property_name

        define_method(method_name) do |input = nil, &block|
          if input.nil? && block.nil?
            public_send(property_name)
          elsif input.nil? && !block.nil?
            public_send("#{property_name}=", block)
          elsif !input.nil?
            public_send("#{property_name}=", input)
          end
        end
      end
    end
  end
end
