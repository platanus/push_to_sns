class <%= class_name %>Notifier < PushToSNS::PushNotifier
  message "<%= human_name %>"
  type :<%= singular_name %>

  attr_accessor <%= attributes.map { |attribute| ":#{attribute.name}" }.join(", ") %>

  def devices
    fail PushToSNS::Messages::DEVICES_METHOD_NOT_IMPLEMENTED
  end

  def notification(device)
    fail PushToSNS::Messages::NOTIFICATION_METHOD_NOT_IMPLEMENTED
  end
end
