require 'net/http'

class FetchCountryService
  attr_reader :ip

  def initialize(ip)
    @ip = ip
  end

  def perform
    # uri
    uri = URI("http://ip-api.com/json/#{ip}")

    # peticion a la api con la clase Net::HTTP
    response = Net::HTTP.get(uri)

    # Parsiamos JSON
    parsed_response = JSON.parse(response)

    # Obtenemos el estado de la peticio
    status = parsed_response.dig("status")

    # Condicion para el error NoMethodError nil:class
    if status == 'success'
      # obtenemos del json parseado el country
      parsed_response.dig('countryCode').downcase
    else
      nil
    end
  # Si existe una excepcion en la llamada a la api devolvemos nil
  rescue
    nil
  end
end