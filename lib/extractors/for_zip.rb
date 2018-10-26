require_relative 'base'
require 'zip'

module Extractors
  class ForZip < Extractors::Base
    def extract
      extracted_filename = nil

      Zip::File.open(file) do |zip_file|
        zip_file.each do |entry|
          entry_name = extract_base_filename(entry.name)
          next unless entry_name == base_filename

          extracted_filename = "#{destination}/#{entry_name}#{File.extname(entry.name)}"
          entry.extract(extracted_filename) { true } # to overwrite existing file
        end
      end

      extracted_filename
    end
  end
end
