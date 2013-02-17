require 'rails/generators'

module Multitenant
  class InstallGenerator < Rails::Generators::Base
    desc "copy config file into rails app"

    CONFIG_FILE_NAME = 'multitenant_mysql_conf.rb'

    def copy_conf_file_into_app
      dest = Rails.root.to_s + "/config/#{CONFIG_FILE_NAME}"
      return if FileTest.exist?(dest) # to prevent overwritting of existing file
      src = File.expand_path(File.dirname(__FILE__)) + "/templates/#{CONFIG_FILE_NAME}"
      FileUtils.copy_file src, dest
      p "The file was created `#{dest}`"
    end

  end
end
