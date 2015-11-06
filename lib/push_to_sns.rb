require_relative "./push_to_sns/version"
require_relative "./push_to_sns/configuration"
require_relative "./push_to_sns/setup_push_notifications"

module PushToSNS
  def self.configure(&block)
    configuration.instance_eval(&block)
  end

  def self.configuration
    @configuration ||= PushToSNS::Configuration.new
  end

  def self.setup_device(device)
    PushToSNS::SetupPushNotifications.new(device).perform
  end
end
