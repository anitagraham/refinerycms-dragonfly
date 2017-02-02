require 'dragonfly'
require 'dragonfly/railtie'
require 'dragonfly/model/validations'
require 'refinerycms'
require 'refinerycms-dragonfly'
require 'active_record'

module Refinery
  module Dragonfly

    describe '.configure!', type: :feature do
      def configure_dragonfly(name, options)
        ::Refinery::Dragonfly.configure!(name, options)
      end

      it 'has a default configuration' do
        configure_dragonfly(:test1, {})
        expect(::Dragonfly.app(:test1).server.verify_urls).to be(true)
      end

      it 'handles configuration changes' do
        configure_dragonfly(:test2, {verify_urls: false})
        expect(::Dragonfly.app(:test2).server.verify_urls).to be(false)
      end

      it 'ignores invalid configuration keys' do
        configure_dragonfly(:testinvalid, {unknown_key: 'funny_value'})

      end

      it 'handles applications with different configurations' do
        configure_dragonfly(:test3, {datastore_root_path: 'test/test3'})
        configure_dragonfly(:test4, {datastore_root_path: 'test/test4'})
        expect(::Dragonfly.app(:test3).datastore.root_path).to eq('test/test3')
        expect(::Dragonfly.app(:test4).datastore.root_path).to eq('test/test4')
      end

    end

    describe '.attach!', type: :feature do


      it 'inserts the Dragonfly app into the Middleware Stack' do

        app = Rails.application
        puts app.nil? ? "Nil" : "something"
        app.configure do
          config.action_controller.perform_caching = true
          config.action_dispatch.rack_cache = true
        end

        ::Refinery::Dragonfly.attach!(::Rails.application, :test, true)
        expect(middlewarestack).to include(Dragonfly::App)

      end

      it 'sets RackCache logging verbosity' do

      end
    end
  end
end



# def app_with_middleware
#   @app_with_middleware ||= Class.new(Rails.application.class) do
#     config.middleware.insert_after \
#         ActionDispatch::ParamsParser, ReadsFromRackInput
#   end
# end
#
# # `app´ is what RSpec tests against in request specs. Think `controller´
# # for controller specs. Overwrite it with our infected app.
# def app; @app ||= app_with_middleware end
# require 'rack'
# require 'rack/cache'
# require 'rack/server'

# Simple Rack respoonse and App

# class HelloWorld
#
#   def response
#     [200, {}, 'Hello World']
#   end
#
# end
#
# class HelloWorldApp
#
#
#   def self.call(env)
#     HelloWorld.new.response
#   end
# end

def look_at_middleware(application)
  def middleware_classes(application)
    r = [application]
    while ((next_app = r.last.instance_variable_get(:@app)) != nil)
      r << next_app
    end
    r.map { |e| e.instance_variable_defined?(:@app) ? e.class : e }
  end
  puts middleware_classes(application)
end
