# frozen_string_literal: true

require 'dry/monads/result'

class ProcessWebFile
  include Dry::Monads::Result::Mixin

  TARGET_ENCODING = 'utf-8'.freeze

  attr_reader :url, :destination

  def self.call(url:, destination:)
    new(url: url, destination: destination).call
  end

  def initialize(url:, destination:)
    @url          = url
    @destination  = destination
  end

  def call
    result = download_from_url.bind do |downloaded_file|
      extract_if_needed(downloaded_file).bind do |raw_document|
        encode_if_needed(raw_document)
      end
    end

    if result.success?
      U.logger.info("processed into #{result.success}")
    else
      U.logger.info("processing failed with #{result.failure}")
    end
  end

  private

  def download_from_url
    downloaded_file = downloader.download
    downloaded_file ? Success(downloaded_file) : Failure('file not downloaded properly')
  end

  def extract_if_needed(file)
    extracted_file = extractor(file).extract
    extracted_file ? Success(extracted_file) : Failure('file not extracted properly')
  end

  def encode_if_needed(file)
    encoded_file = encoder(file).encode
    encoded_file ? Success(encoded_file) : Failure('file not encoded properly')
  end

  def downloader
    Downloader.new(raw_uri: url, destination: destination)
  end

  def extractor(file)
    Extractor.new(file: file, destination: destination)
  end

  def encoder(file)
    Encoder.new(file: file, encoding: TARGET_ENCODING)
  end
end
