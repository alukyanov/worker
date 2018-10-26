# frozen_string_literal: true

class Encoder
  attr_reader :file, :encoding

  MEGABYTE = 2**20
  KILOBYTE = 2**10
  CHUNK_SIZE = MEGABYTE
  DETECT_ENCODING_SIZE = KILOBYTE
  TARGET_ENCODING = 'utf-8'.freeze

  def initialize(file:, encoding:)
    @file = file
    @encoding = encoding
  end

  def encode
    return file if already_in_target_encoding?
    return unless encoding_info_valid?

    encoded_tmp_file = encode_to_tmp_file
    FileUtils.mv(encoded_tmp_file, file)

    file
  rescue => e
    U.logger.exception(e)
    nil
  end

  private

  def encode_to_tmp_file
    tmp_filename = "#{file}.tmp"

    File.open(tmp_filename, 'wb') do |final|
      File.open(file, 'rb') do |input|
        while chunk = input.read(CHUNK_SIZE)
          final.write converter.convert(chunk)
        end
      end
    end

    tmp_filename
  end

  def already_in_target_encoding?
    encoding_info['encoding'] == TARGET_ENCODING
  end

  def encoding_info_valid?
    encoding_info['confidence'] > 0.9
  end

  def converter
    @converter ||= Encoding::Converter.new(file_encoding, TARGET_ENCODING)
  end

  def file_encoding
    @file_encoding ||= encoding_info['encoding']
  end

  def encoding_info
    @encoding_info ||= CharDet.detect(IO.binread(file, DETECT_ENCODING_SIZE))
  end
end
