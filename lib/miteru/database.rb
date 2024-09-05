# frozen_string_literal: true

class V2Schema < ActiveRecord::Migration[7.2]
  def change
    create_table :records, if_not_exists: true do |t|
      t.string :sha256, null: false, index: {unique: true}
      t.string :hostname, null: false
      t.json :headers, null: false
      t.text :filename, null: false
      t.string :downloaded_as, null: false
      t.integer :filesize, null: false
      t.string :mime_type, null: false
      t.text :url, null: false
      t.string :source, null: false

      t.timestamps
    end
  end
end

#
# @return [Array<ActiveRecord::Migration>] schemas
#
def schemas
  [V2Schema]
end

module Miteru
  class Database
    class << self
      #
      # DB migration
      #
      # @param [Symbol] direction
      #
      def migrate(direction)
        schemas.each { |schema| schema.migrate direction }
      end

      #
      # Establish DB connection
      #
      def connect
        return if connected?

        ActiveRecord::Base.establish_connection Miteru.config.database_url.to_s
        ActiveRecord::Base.logger = Logger.new($stdout) if Miteru.development?
      end

      #
      # @return [Boolean]
      #
      def connected?
        ActiveRecord::Base.connected?
      end

      #
      # Close DB connection(s)
      #
      def close
        return unless connected?

        ActiveRecord::Base.connection_handler.clear_active_connections!
      end

      def with_db_connection
        Miteru::Database.connect unless connected?
        yield
      rescue ActiveRecord::StatementInvalid
        Miteru.logger.error("DB migration is not yet complete. Please run 'miteru db migrate'.")
      ensure
        Miteru::Database.close
      end

      private

      def adapter
        return "postgresql" if %w[postgresql postgres].include?(Miteru.config.database_url.scheme)
        return "mysql2" if Miteru.config.database_url.scheme == "mysql2"

        "sqlite3"
      end
    end
  end
end
