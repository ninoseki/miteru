# frozen_string_literal: true

require "miteru/commands/database"

module Miteru
  module CLI
    class Database < Base
      include Commands::Database
    end
  end
end
