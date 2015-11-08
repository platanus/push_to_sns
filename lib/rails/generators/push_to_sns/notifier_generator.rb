module PushToSns # We need this name to help Rails generators lookup
  module Generators
    # rails generate push_to_sns:notifier new_goal goal
    class NotifierGenerator < Rails::Generators::NamedBase
      desc "Create a new PushToSNS notifier"
      argument :attributes,
        type: :array,
        default: [],
        banner: "attribute attribute ..."

      def self.source_root
        @source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_notifier
        template "notifier.rb", File.join(
          "app/push_notifiers", "#{file_name}_notifier.rb"
        )
      end
    end
  end
end
