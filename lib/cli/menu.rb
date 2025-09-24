require_relative "../services/api_client"
require_relative "../models/db"

module CLI
  class Menu
    def initialize(api_client, db)
      @api = api_client
      @db  = db
    end

    def start
      loop do
        puts "\n=== GamesYpromos ==="
        puts "1) Jogos grátis por plataforma"
        puts "2) Promoções por plataforma"
        puts "3) Buscar jogo"
        puts "4) Sair"
        print "Escolha uma opção (1-4): "
        choice = gets.chomp.strip

        case choice
        when "1"
          free_giveaways_by_platform
        when "2"
          giveaways_by_platform
        when "3"
          search_game
        when "4"
          puts "Saindo..."
          break
        else
          puts "Opção inválida. Digite um número de 1 a 4."
        end
      end
    end

    private

    def free_giveaways_by_platform
      platform = prompt_for_platform
      return unless platform

      giveaways = @api.fetch_giveaways(platform: platform, type: "game")
      process_and_display(giveaways)
    rescue => e
      puts "Erro: #{e.message}"
    end

    def giveaways_by_platform
      platform = prompt_for_platform
      return unless platform

      giveaways = @api.fetch_giveaways(platform: platform)
      process_and_display(giveaways)
    rescue => e
      puts "Erro: #{e.message}"
    end

    def search_game
      print "Digite o nome do jogo: "
      name = gets.chomp.strip
      if name.empty?
        puts "O nome do jogo não pode estar vazio."
        return
      end

      giveaways = @api.search_giveaways(game_name: name)
      process_and_display(giveaways)
    rescue => e
      puts "Erro: #{e.message}"
    end

    def prompt_for_platform
      platforms = valid_platforms
      puts "\nSelecione a plataforma:"
      platforms.each_with_index do |plat, idx|
        puts "#{idx + 1}) #{plat}"
      end
      print "Digite o número: "
      sel = gets.chomp.to_i
      if sel < 1 || sel > platforms.size
        puts "Seleção inválida."
        return nil
      end
      platforms[sel - 1]
    end

    def valid_platforms
      %w[
        pc steam epic-games-store ubisoft gog itchio
        ps4 ps5 xbox-one xbox-series-xs switch android ios
        vr battlenet origin drm-free xbox-360
      ]
    end

    def process_and_display(list)
      if list.nil? || !list.is_a?(Array) || list.empty?
        puts "\nNenhuma promoção encontrada."
        return
      end

      # Save to DB
      list.each do |gw|
        @db.save_giveaway(gw)
      end

      display_giveaways(list)
    end

    def display_giveaways(list)
      puts "\n== Promoções Encontradas =="
      list.each do |gw|
        title  = gw["title"] || "Sem título"
        
        
        plats  = if gw["platforms"]
                   case gw["platforms"]
                   when Array
                     gw["platforms"].join(", ")
                   when String
                     gw["platforms"]
                   else
                     gw["platforms"].to_s
                   end
                 else
                   "Não informado"
                 end
        
        ends   = gw["end_date"] || "Data não informada"
        worth  = gw["worth"] || "Grátis"
        url    = gw["open_giveaway_url"] || "Link não disponível"

        puts "Título: #{title}"
        puts "Plataformas: #{plats}"
        puts "Valor: #{worth}"
        puts "Termina em: #{ends}"
        puts "Link: #{url}"
        puts "-" * 50
      end
      puts "\nTotal: #{list.size} promoções encontrada(s)"
    end
  end
end
