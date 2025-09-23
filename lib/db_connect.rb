require "pg"

begin
  connection = PG.connect(
    dbname: "gamesypromos",
    user: "gamesypromos",
    password: "gamesypromos",
    host: "localhost",
    port: 5432
  )
  
rescue PG::Error => e
  puts "Database connection failed: #{e.message}"
ensure
  connection&.close
end
