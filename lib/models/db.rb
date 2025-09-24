# lib/models/db.rb

require "pg"

module Models
  class DB
    def initialize(config)
      @conn = PG.connect(config)
    end

    def save_giveaway(gw)
      giveaway_id = gw["id"]
      title        = gw["title"]
      description  = gw["description"]
      image         = gw["image"]
      worth         = gw["worth"]
      end_date      = gw["end_date"]
      platforms     = case gw["platforms"]
                      when Array
                        gw["platforms"].join(",")
                      when String
                        gw["platforms"]
                      else
                        nil
                      end
      type_field    = gw["type"]
      status        = gw["status"]
      url           = gw["open_giveaway_url"]

      sql = <<~SQL
        INSERT INTO giveaways (
          giveaway_id, title, description, image, worth,
          end_date, platforms, type, status, url, created_at, updated_at
        ) VALUES (
          $1, $2, $3, $4, $5,
          $6, $7, $8, $9, $10, NOW(), NOW()
        )
        ON CONFLICT (giveaway_id) DO UPDATE
        SET title        = EXCLUDED.title,
            description  = EXCLUDED.description,
            image        = EXCLUDED.image,
            worth        = EXCLUDED.worth,
            end_date     = EXCLUDED.end_date,
            platforms    = EXCLUDED.platforms,
            type         = EXCLUDED.type,
            status       = EXCLUDED.status,
            url          = EXCLUDED.url,
            updated_at   = NOW();
      SQL

      params = [
        giveaway_id, title, description, image, worth,
        end_date, platforms, type_field, status, url
      ]

      @conn.exec_params(sql, params)
    rescue PG::Error => e
      puts "#{e.message}"
    end

    def close
      @conn.close if @conn
    end
  end
end
