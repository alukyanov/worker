module Extractors
  class Base
    attr_reader :file, :destination

    def initialize(file, destination)
      @file         = file
      @destination  = destination
    end

    def extract
      raise NotImplementedError
    end

    protected

    def base_filename
      extract_base_filename(file)
    end

    def extract_base_filename(file)
      File.basename(file, File.extname(file))
    end
  end
end
