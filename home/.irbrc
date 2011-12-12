# History
require 'irb/completion'
require 'irb/ext/save-history'
IRB.conf[:SAVE_HISTORY] = 1000
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-history"

require 'rubygems'
begin
  # load wirble
  require 'wirble'

  # start wirble (with color)
  Wirble.init({:skip_history => true})
  Wirble.colorize
rescue LoadError => err
  warn "Couldn't load Wirble: #{err}"
end
require 'pp'

if defined? Rails && Rails.env
  require 'logger'
  logger = Logger.new(STDOUT)
  ActiveRecord::Base.logger = logger if defined? ActiveRecord
  ActiveResource::Base.logger = logger if defined? ActiveResource
end

if ENV['RAILS_ENV']
  require 'logger'
  Object.const_set('RAILS_DEFAULT_LOGGER', Logger.new(STDOUT)) # Rails 2
end
#
# Prompt behavior
IRB.conf[:USE_READLINE] = true # Adds readline functionality
#IRB.conf[:PROMPT_MODE] = :SIMPLE
