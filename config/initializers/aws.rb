RAILS_ROOT ||= ENV['RAILS_ROOT'] || File.expand_path(File.dirname(__FILE__) + '/../..')
RAILS_ENV ||= ENV['RAILS_ENV'] || 'development'

require "#{RAILS_ROOT}/config/pref" unless defined?(Pref)

AWS.config(
  access_key_id: Pref::AWS::KEY,
  secret_access_key: Pref::AWS::SECRET
)
