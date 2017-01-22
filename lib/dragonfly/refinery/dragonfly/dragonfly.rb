require 'dragonfly'

module RefineryDragonfly
  class << self
    def configure!(app_name, options)
      ActiveRecord::Base.extend ::Dragonfly::Model
      ActiveRecord::Base.extend ::Dragonfly::Model::Validations

      options = options.merge!(Refinery::Dragonfly.config)
      app = ::Refinery::Dragonfly.app(app_name)

      app.configure do

        plugin :imagemagick
        datastore :file, {
          :root_path => options.datastore_root_path
        } if options.datastore_root_path

        allow_legacy_urls     	options.allow_legacy_urls     if options.allow_legacy_urls.presence?
        analyser 						    options.analyser              if options.analyser.presence?
        before_serve 						options.before_serve          if options.before_serve.presence?
        # datastore 							options.datastore             if options.datastore.presence?
        define_url 							options.define_url            if options.define_url.presence?
        fetch_file_whitelist 		options.fetch_file_whitelist  if options.fetch_file_whitelist.presence?
        fetch_url_whitelist 		options.fetch_url_whitelist   if options.fetch_url_whitelist.presence?
        first_bytes 						options.first_bytes           if options.first_bytes.presence?
        generator               options.generator             if options.generator.presence?
        insert_before           options.insert_before         if options.insert_before.presence?
        mime_type               options.mime_type             if options.mime_type.presence?
        # plugin                  options.plugin                if options.plugin.presence?
        processor               options.processor             if options.processor.presence?
        url                     options.url                   if options.url.presence?
        url_format              options.url_format            if options.url_format.presence?
        url_host                options.url_host              if options.url_host.presence?
        path_prefix             options.path_prefix           if options.path_prefix.presence?
        processor               options.processor             if options.processor.presence?
        response_header         options.response_header       if options.response_header.presence?
        secret                  options.secret                if options.secret.presence?
        url_scheme              options.url_scheme            if options.url_scheme.presence?
        verify_urls             options.verify_urls           if options.verify_urls.presence?


TODO        # define_url do | app, job, opts|
        #   thumb = Refinery::Caststone::Thumb.find_by_signature(job.signature)
        #   if thumb
        #     app.datastore.url_for(thumb.uid)
        #   else
        #     app.server.url_for(job)
        #   end
        # end
        # Before serving from the local Dragonfly server...

TODO        # before_serve do |job, env|
        #   uid = job.store
        #   Refinery::Caststone::Thumb.create!(uid: uid, signature: job.signature)
        # end
      end

      if options.s3_backend
        require 'dragonfly/s3_data_store'
        datastore :file, {
          bucket_name: options.s3_bucket_name,
          access_key_id: options.s3_access_key_id,
          secret_access_key: options.s3_secret_access_key,
          url_scheme: options.s3_url_scheme
        }.tap { |ds|
          # S3 Region otherwise defaults to 'us-east-1'
          ds.region = options.s3_region if options.s3_regions
        }
      end

      # Logger
      Dragonfly.logger = Rails.logger

      if options.custom_backend?
        app.datastore = options.custom_backend_class.new(options.custom_backend_opts)
      end
    end


    def attach!(app)
      # Injects Dragonfly::Middleware into the stack
      if defined?(::Rack::Cache)
        unless app.config.action_controller.perform_caching && app.config.action_dispatch.rack_cache
          app.config.middleware.insert 0, ::Rack::Cache, {
            verbose: app.config.verbose_cache_logging,
            metastore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/meta"), # URI encoded in case of spaces
            entitystore: URI.encode("file:#{Rails.root}/tmp/dragonfly/cache/body")
          }
        end
        app.config.middleware.insert_after ::Rack::Cache, ::Dragonfly::Middleware, options.name
      else
        app.config.middleware.use ::Dragonfly::Middleware, options.name
      end
    end
  end
end
