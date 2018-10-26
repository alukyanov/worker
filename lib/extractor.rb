# frozen_string_literal: true

require_relative '../lib/extractors/for_gz'
require_relative '../lib/extractors/for_zip'

class Extractor
  attr_reader :file, :destination

  STRATEGIES = {
    'gz'  => Extractors::ForGz,
    'zip' => Extractors::ForZip
  }.freeze

  AVAILABLE_FORMATS = STRATEGIES.keys.to_set

  def initialize(file:, destination:)
    @file = file
    @destination = destination
  end

  def extract
    return file unless need_extract?

    strategy_to_extract.new(file, destination).extract.tap do
      delete_original_file
    end
  rescue => e
    U.logger.exception(e)
    nil
  end

  private

  def need_extract?
    AVAILABLE_FORMATS.include?(file_ext)
  end

  def delete_original_file
    File.delete(file)
  end

  def strategy_to_extract
    STRATEGIES[file_ext]
  end

  def file_ext
    @file_ext ||= File.extname(file)[1..-1]
  end
end
