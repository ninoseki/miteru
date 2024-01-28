# frozen_string_literal: true

module Miteru
  module Commands
    module Database
      class << self
        def included(thor)
          thor.class_eval do
            include Concerns::DatabaseConnectable

            desc "migrate", "Migrate DB schemas"
            around :with_db_connection
            method_option :verbose, type: :boolean, default: true
            def migrate(direction = "up")
              ActiveRecord::Migration.verbose = options["verbose"]
              Miteru::Database.migrate direction.to_sym
            end
          end
        end
      end
    end
  end
end
