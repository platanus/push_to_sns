require_relative "./push_to_sns/version"
require_relative "./push_to_sns/configuration"

module PushToSNS
  def self.configure(&block)
    configuration.instance_eval(&block)
  end

  def self.configuration
    @configuration ||= PushToSNS::Configuration.new
  end
end
