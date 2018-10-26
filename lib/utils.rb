module Utils
  module_function def logger
    @logger ||= Logger.new(STDOUT)
  end
end
U = Utils
