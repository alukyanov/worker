require 'uri/http'
require 'net/http'

class Downloader
  attr_reader :uri, :destination

  def initialize(raw_uri:, destination:)
    @uri = URI.parse(raw_uri)
    @destination = destination
  end

  def download
    Net::HTTP.start(uri.host) do |http|
      http.request request do |response|
        File.open(filepath, 'w') do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end

    filepath
  rescue => e
    U.logger.exception(e)
    nil
  end

  private

  def request
    Net::HTTP::Get.new(request_uri)
  end

  def filepath
    @filepath ||= File.join(destination, fname_from_uri)
  end

  def fname_from_uri
    @fname_from_uri ||= request_uri.split('?').first.split('/').last
  end

  def request_uri
    @request_uri ||= uri.request_uri
  end
end
