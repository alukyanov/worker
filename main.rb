require_relative 'config/boot'

Dir[File.join(__dir__, 'monads', '**', '*.rb')].each(&method(:require))
Dir[File.join(__dir__, 'lib', '**', '*.rb')].each(&method(:require))


ProcessWebFile.call(url: ENV['DOCURL'], destination: ENV['DEST_DIR'] || '/tmp')
