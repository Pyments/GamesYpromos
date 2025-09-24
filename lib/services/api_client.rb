require "httparty"
require "json"

module Services
  class ApiClient
    include HTTParty
    base_uri "https://gamerpower.com/api"

    def fetch_giveaways(platform: nil, type: nil, sort_by: nil)
      query_params = {}
      query_params[:platform] = platform if platform
      query_params[:type]     = type     if type
      query_params["sort-by"] = sort_by  if sort_by

      resp = self.class.get("/giveaways", query: query_params)
      check_response(resp)
      parse_response(resp)
    end

    def fetch_giveaway(id:)
      raise ArgumentError, "id is required" if id.nil? || id.to_s.strip.empty?

      resp = self.class.get("/giveaway", query: { id: id })
      check_response(resp)
      parse_response(resp)
    end

    def search_giveaways(game_name:)
      return [] if game_name.nil? || game_name.strip.empty?

      all = fetch_giveaways
      all.select do |gw|
        title = gw["title"] || ""
        title.downcase.include?(game_name.downcase)
      end
    end

    private

    def check_response(response)
      unless response.code == 200
        raise "HTTP Error: #{response.code} #{response.message}"
      end
    end

    def parse_response(response)
      begin
        data = JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise "JSON parse error: #{e.message}"
      end
      data
    end
  end
end
