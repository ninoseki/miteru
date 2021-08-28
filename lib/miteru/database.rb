# frozen_string_literal: true

require "active_record"

class InitialSchema < ActiveRecord::Migration[6.1]
  def change
    create_table :records, if_not_exists: true do |t|
      t.string :hash, null: false, index: { unique: true }
      t.string :hostname, null: false
      t.json :headers, null: false
      t.text :filename, null: false
      t.string :downloaded_as, null: false
      t.integer :filesize, null: false
      t.string :mime_type, null: false
      t.text :url, null: false

      t.timestamps
    end
  end
end

def adapter
  return "postgresql" if Miteru.configuration.database.start_with?("postgresql://", "postgres://")
  return "mysql2" if Miteru.configuration.database.start_with?("mysql2://")

  "sqlite3"
end

module Miteru
  class Database
    class << self
      def connect
        case adapter
        when "postgresql", "mysql2"
          ActiveRecord::Base.establish_connection(Miteru.configuration.database)
        else
          ActiveRecord::Base.establish_connection(
            adapter: adapter,
            database: Miteru.configuration.database
          )
        end

        # ActiveRecord::Base.logger = Logger.new STDOUT
        ActiveRecord::Migration.verbose = false

        InitialSchema.migrate(:up)
      rescue StandardError => _e
        # Do nothing
      end

      def close
        ActiveRecord::Base.clear_active_connections!
        ActiveRecord::Base.connection.close
      end

      def destroy!
        return unless ActiveRecord::Base.connected?

        InitialSchema.migrate(:down)
      end
    end
  end
end

Miteru::Database.connect
