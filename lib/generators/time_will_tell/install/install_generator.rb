# encoding: UTF-8
module TimeWillTell
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Copy TimeWillTell default files"
      source_root File.expand_path(File.join(File.dirname(__FILE__), 'templates'))

      def copy_locales
        directory 'config/locales'
      end
    end
  end
end
