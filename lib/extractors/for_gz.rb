require_relative 'base'
require 'zlib'

module Extractors
  class ForGz < Extractors::Base
    CHUNK_SIZE = 2**20 # 1 megabyte

    def extract
      extracted_filename = "#{destination}/#{File.basename(file, '.gz')}"

      File.open(extracted_filename, 'wb') do |final|
        File.open(file) do |input|
          gz = Zlib::GzipReader.new(input)

          while chunk = gz.read(CHUNK_SIZE)
            final.write chunk
          end
        end
      end

      extracted_filename
    end
  end
end
