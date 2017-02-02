require 'dragonfly'

module Refinery
  module Dragonfly


    class << self


        def configure!(app_name, options)
        ::ActiveRecord::Base.extend ::Dragonfly::Model
        ::ActiveRecord::Base.extend ::Dragonfly::Model::Validations


        # merge options supplied by the application with the default options defined by Refinery::Dragonfly
        # reject any options not defined in Refinery::Dragonfly.config

        options = config.dragonfly_options.merge(options.slice(*config.dragonfly_options.keys)){
          |key, default, option| options.present? ? option : default
        }

        s3_options = config.s3_options.merge(options.slice(*config.s3_options.keys))

        ::Dragonfly.app(app_name).configure do

          # These options always have a value set
          # Refinery::Dragonfly will supply a value if the application doesn't
          datastore :file,  {root_path: options.datastore_root_path || (Rails.root.join('public', 'system', 'refinery', 'images').to_s if Rails.root)}
          plugin options.plugin
          secret options.secret
          url_format options.url_format
          url_host options.url_host

          # These are optional options. If not present Dragonfly will use its defaults
          allow_legacy_urls       options.allow_legacy_urls     if options.allow_legacy_urls.present?
          before_serve            options.before_serve          if options.before_serve.present?
          define_url              options.define_url            if options.define_url.present?
          fetch_file_whitelist    options.fetch_file_whitelist  if options.fetch_file_whitelist.present?
          fetch_url_whitelist     options.fetch_url_whitelist   if options.fetch_url_whitelist.present?
          first_bytes             options.first_bytes           if options.first_bytes.present?
          insert_before           options.insert_before         if options.insert_before.present?
          mime_type               options.mime_type             if options.mime_type.present?
          url                     options.url                   if options.url.present?
          path_prefix             options.path_prefix           if options.path_prefix.present?
          response_header         options.response_header       if options.response_header.present?
          # Dragonfly's default is true, so only send this if it is false
          verify_urls             options.verify_urls           if !options.verify_urls

          # These options require a name and block
          #
          # example (from refinerycms-images):
          # strip => (content) { content.process!(:convert, '-strip') }
          #  self.dragonfly_options = {
          #    ...
          #    processors: [{name: :strip, block: strip }]
          #    ...
          #  }

          define_url      options.define_url.name, options.define_url.block      if options.define_url.present?
          before_serve    options.before_serve.name, options.before_serve.block  if options.before_serve.present?

          # There can be more than one instance of each of these options. They also take a name and a block
          options.analysers.each do |a|
            analyser a.name, a.block
          end unless options.analysers.empty?

          options.generators.each do |g|
            generator g.name, g.block
          end unless options.generators.empty?

          options.processors.each do |p|
            processor p.name, p.block
          end unless options.processors.empty?

          if s3_options.s3_backend
            require 'dragonfly/s3_data_store'
            datastore :s3, s3_options
          end

        end
      end

      def attach!(app, accessor, verbose_logging)

        # Injects Dragonfly::Middleware into the stack
        if defined?(::Rack::Cache)
          unless app.config.action_controller.perform_caching && application.config.action_dispatch.rack_cache
            app.config.middleware.insert 0, ::Rack::Cache, {
              verbose: verbose_logging,
              metastore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"), # URI encoded in case of spaces
              entitystore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")
            }
          end
          app.config.middleware.insert_after ::Rack::Cache, ::Dragonfly::Middleware, accessor
        else
          app.config.middleware.use ::Dragonfly::Middleware, name
        end
      end
    end
  end

end
