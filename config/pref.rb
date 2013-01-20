module Pref
  RAILS_ROOT = File.expand_path("#{File.dirname(__FILE__)}/../")
  RAILS_ENV = (ENV['RAILS_ENV'] || ENV['RACK_ENV'] || 'development')

  unless defined?(::Rails)
    module ::Rails
      class << self
        def root; RAILS_ROOT; end
        def env; RAILS_ENV; end
      end
    end
  end

  module AWS
    KEY = 'AKIAIOQ4BVQW426SIRFA'
    SECRET = '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'
    BUCKETNAME = 'pairful-development'
    BUCKET_PATH = {
      image: {path: 'pairful/image', extension: 'png'},
    }
  end

end
