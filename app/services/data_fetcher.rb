class DataFetcher
  # Handles data retrieval from different sources

  def initialize(source, type: :json)
    @source = source
    @type = type
  end

  def perform
    case type
    when :json
      fetch_from_json
    else
      raise "Unsupported data type: #{type}"
    end
  end

  private

  attr_reader :source, :type

  def fetch_from_json
    JSON.parse(File.read(source))
  end
end
