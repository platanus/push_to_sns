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
      defaults = { type: type, message: message }
      defaults.merge(notification(device))
    end

    def type
      @type ||= self.class.type
    end

    def message
      @message ||= self.class.message
    end

    class << self
      attr_accessor :input_type, :input_message

      def type(input_type = nil)
        if input_type.nil?
          self.input_type
        else
          self.input_type = input_type
        end
      end

      def message(input_message = nil)
        if input_message.nil?
          self.input_message
        else
          self.input_message = input_message
        end
      end
    end
  end
end
