#!/usr/bin/env ruby

require_relative "services/api_client"
require_relative "models/db"
require_relative "cli/menu"
require_relative "GamesYpromos/version"

DB_CONFIG = {
  dbname:   "gamesypromos",
  user:     "gamesypromos",
  password: "gamesypromos",
  host:     "localhost",
  port:     5432
}

def main
  api_client = Services::ApiClient.new
  db         = Models::DB.new(DB_CONFIG)
  menu       = CLI::Menu.new(api_client, db)
  menu.start
  db.close
end

if __FILE__ == $0
  main
end
