class ApiClient
  include HTTParty
  base_uri 'https://v3.football.api-sports.io'

  def initialize
    @headers = {
      'x-apisports-key' => ENV['API_SPORTS_KEY'],
      'Content-Type'    => 'application/json'
    }
    @api_usage = ApiUsage.first_or_create!(limit: ENV['API_LIMIT'].to_i, usage: 0, last_reset: Date.today)
  end

  def fetch(endpoint, params = {})
    reset_usage_if_needed
    raise "API limit reached for today" if api_limit_reached?

    response = self.class.get("/#{endpoint}", headers: @headers, query: params)

    if response.success?
      increment_usage
      response.parsed_response['response']
    else
      Rails.logger.error "Error fetching #{endpoint}: #{response.message}"
      []
    end
  end

  def reset_usage_if_needed
    if @api_usage.last_reset != Date.today
      @api_usage.update!(usage: 0, last_reset: Date.today)
    end
  end

  def api_limit_reached?
    @api_usage.usage >=  @api_usage.limit
  end

  def increment_usage(count = 1)
    @api_usage.increment!(:usage, count)
  end
end
