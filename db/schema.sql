CREATE DATABASE IF NOT EXISTS gamesypromos;

\c gamesypromos;

CREATE TABLE IF NOT EXISTS giveaways (
    id SERIAL PRIMARY KEY,
    giveaway_id INTEGER UNIQUE NOT NULL,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    worth VARCHAR(50),
    end_date VARCHAR(100),
    platforms TEXT,
    type VARCHAR(50),
    status VARCHAR(50),
    url VARCHAR(500),
    created_at TIMESTAMP DEFAULT NOW(),
    updated_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_giveaway_id ON giveaways(giveaway_id);
CREATE INDEX IF NOT EXISTS idx_title ON giveaways(title);
