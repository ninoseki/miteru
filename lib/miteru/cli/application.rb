# frozen_string_literal: true

require "thor"
require "thor/hollaback"

require "miteru/cli/base"
require "miteru/cli/database"

require "miteru/commands/main"
require "miteru/commands/sidekiq"
require "miteru/commands/web"

module Miteru
  module CLI
    #
    # Main CLI class
    #
    class App < Base
      include Commands::Main
      include Commands::Sidekiq
      include Commands::Web

      desc "db", "Sub commands for DB"
      subcommand "db", CLI::Database
    end
  end
end
