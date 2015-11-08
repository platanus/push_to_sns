module PushToSns # We need this name to help Rails generators lookup
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Create PushToSNS configuration initializer"

      def self.source_root
        @source_root ||= File.expand_path("../templates", __FILE__)
      end

      def create_config_initializer
        copy_file "config/initializers/push_to_sns.rb"
      end
    end
  end
end
