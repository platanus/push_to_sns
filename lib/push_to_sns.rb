require "json"
require "deep_merge/rails_compat"
require_relative "./push_to_sns/version"
require_relative "./push_to_sns/messages"
require_relative "./push_to_sns/configuration"
require_relative "./push_to_sns/setup_push_notification"
require_relative "./push_to_sns/push_notifier"
require_relative "./push_to_sns/send_push_notification"
require_relative "./push_to_sns/basic_push_notification"
require_relative "./push_to_sns/ios_push_notification"
require_relative "./push_to_sns/android_push_notification"

module PushToSNS
  def self.configure(&block)
    configuration.instance_eval(&block)
  end

  def self.configuration
    @configuration ||= PushToSNS::Configuration.new
  end

  def self.setup_device(device)
    PushToSNS::SetupPushNotification.new(device).perform
  end
end
