# frozen_string_literal: true

module Miteru
  module Commands
    module Main
      class << self
        def included(thor)
          thor.class_eval do
            include Concerns::DatabaseConnectable

            method_option :auto_download, type: :boolean, default: false,
              desc: "Enable or disable auto-downloading of phishing kits"
            method_option :directory_traveling, type: :boolean, default: false,
              desc: "Enable or disable directory traveling"
            method_option :download_to, type: :string, default: "/tmp", desc: "Directory to download phishing kits"
            method_option :threads, type: :numeric, desc: "Number of threads to use", default: Parallel.processor_count
            method_option :verbose, type: :boolean, default: true
            desc "execute", "Excecute the crawler"
            around :with_db_connection
            def execute
              Miteru.config.tap do |config|
                config.auto_download = options["auto_download"]
                config.directory_traveling = options["directory_traveling"]
                config.download_to = options["download_to"]
                config.threads = options["threads"]
                config.verbose = options["verbose"]
              end

              Orchestrator.call
            end
            default_command :execute
          end
        end
      end
    end
  end
end
