module TimeWillTell
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy TimeWillTell default files"
      source_root File.expand_path("../templates", __FILE__)

      def copy_locales
        directory "config/locales"
      end
    end
  end
end
