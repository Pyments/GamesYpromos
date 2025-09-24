# GamesYpromos

Uma aplicação CLI simples em Ruby que busca jogos grátis e promoções de diversas plataformas usando a API do GamerPower e armazena os dados em PostgreSQL.

## Funcionalidades

- Buscar jogos grátis por plataforma
- Buscar promoções por plataforma
- Buscar jogos específicos por nome
- Armazenar dados no PostgreSQL automaticamente
- Interface CLI simples e intuitiva em português

## Requisitos

- Ruby 3.1.0 ou superior
- PostgreSQL
- Bundler gem

## Configuração

1. **Instalar dependências:**
   ```bash
   bundle install
   ```

2. **Configurar banco de dados:**
   ```bash
   # Criar usuário e banco PostgreSQL
   sudo -u postgres createuser gamesypromos
   sudo -u postgres createdb gamesypromos -O gamesypromos
   sudo -u postgres psql -c "ALTER USER gamesypromos PASSWORD 'gamesypromos';"
   
   # Criar tabela
   psql -U gamesypromos -d gamesypromos -f db/schema.sql
   ```

3. **Executar a aplicação:**
   ```bash
   ./bin/gamesypromos
   ```

## Uso

A CLI oferece três opções principais:

1. **Jogos grátis por plataforma** - Busca jogos gratuitos filtrados por plataforma
2. **Promoções por plataforma** - Busca todas as promoções/descontos por plataforma
3. **Buscar jogo** - Busca jogos específicos por nome

Todos os dados obtidos são automaticamente salvos no banco PostgreSQL.

## Plataformas Suportadas

- PC (Steam, Epic Games Store, Ubisoft, GOG, Itch.io)
- PlayStation (PS4, PS5)
- Xbox (Xbox One, Xbox Series X/S, Xbox 360)
- Nintendo Switch
- Mobile (Android, iOS)
- VR
- Battle.net, Origin, DRM-free

## Licença

MIT License
