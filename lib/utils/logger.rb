require 'logger'

module Utils
  class Logger < ::Logger
    def exception(ex)
      error("#{ex.message};#{ex.backtrace}")
    end
  end
end
