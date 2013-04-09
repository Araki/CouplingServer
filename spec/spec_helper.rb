require 'rubygems'
require 'spork'

Spork.prefork do
  unless ENV['DRB']
    require 'simplecov'
  end

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.mock_with :rspec
    config.fixture_path = "#{::Rails.root}/spec/fixtures"
    config.use_transactional_fixtures = true
    config.infer_base_class_for_anonymous_controllers = false

    config.before(:suite) do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean_with(:truncation)
    end

    config.before(:each) do
      DatabaseCleaner.start
    end

    config.after(:each) do
      DatabaseCleaner.clean
    end    
  end

  module Helpers
    def session_verified_user(session)
      time_now = Time.local(2008,12,3,15,0,0)
      Time.stub!(:now).and_return(time_now)

      user = mock(:user)
      User.should_receive(:find_by_id).with(session.value.to_s).and_return(user)
      user.stub!(:update_attribute).with(:last_login_at, time_now).and_return(true)
      user
    end
  end
end

Spork.each_run do
  if ENV['DRB']
    require 'simplecov'
  end

  silence_warnings do
    Dir[Rails.root.join('app/**/*.rb')].each do |file|
      load file
    end
  end

  FactoryGirl.reload
end
