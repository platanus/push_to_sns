module PushToSNS
  class PushNotifier
    def initialize(params = {})
      params.each do |attr, value|
        public_send("#{attr}=", value)
      end
    end

    def deliver
      devices.each do |device|
        begin
          SendPushNotification.new(device).perform(full_notification_for_device(device))
        rescue AWS::SNS::Errors::Base => e
          $stderr.puts "Device can't send push notifications: #{e.message}"
        end
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
        sound: call_or_read(sound, device),
        small_icon: call_or_read(small_icon, device),
        title: call_or_read(title, device),
        image: call_or_read(image, device),
        notId: call_or_read(notification_id, device)
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

    def title
      @title ||= self.class.title
    end

    def image
      @image ||= self.class.image
    end

    def notification_id
      @notification_id ||= self.class.notification_id
    end

    def small_icon
      @small_icon ||= self.class.small_icon
    end

    private

    def call_or_read(proc_or_object, *arguments)
      if proc_or_object.respond_to?(:call)
        instance_exec(*arguments, &proc_or_object)
      else
        proc_or_object
      end
    end

    class << self
      [:type, :message, :badge, :sound, :title, :small_icon, :image, :notification_id].each do |method_name|
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
