module Refinery
  module Dragonfly
    include ActiveSupport::Configurable

# All dragonfly configuration options allowed
    config_accessor :dragonfly_allow_legacy_urls,
    	:dragonfly_analyser,
    	:dragonfly_before_serve,
    	:dragonfly_datastore,
    	:dragonfly_define_url,
    	:dragonfly_fetch_file_whitelist,
    	:dragonfly_fetch_url_whitelist,
    	:dragonfly_first_bytes,
     	:dragonfly_generator,
     	:dragonfly_insert_before,
     	:dragonfly_mime_type,
    	:dragonfly_plugin,
    	:dragonfly_processor,
    	:dragonfly_url,
      :dragonfly_url_format,
      :dragonfly_url_host,
      :dragonfly_path_prefix,
      :dragonfly_processor,
      :dragonfly_response_header,
      :dragonfly_secret,
      :dragonfly_url_scheme,
      :dragonfly_verify_urls,

# s3 Data Store Config
      :s3_bucket_name,
			:s3_access_key_id,
			:s3_secret_access_key,
			:s3_region,               # default 'us-east-1', see Dragonfly :s3_ :s3_S3DataStore :s3_ :s3_REGIONS for options
			:s3_storage_headers,      # defaults to {'x-amz-acl' => 'public-read'}, can be overridden per-write - see below
			:s3_url_scheme,           # defaults to "http"
			:s3_url_host,             # defaults to "<bucket-name>.s3.amazonaws.com", or "s3.amazonaws.com/<bucket-name>" if not a valid subdomain
			:s3_use_iam_profile,      # boolean - if true, no need for access_key_id or secret_access_key
			:s3_root_path,            # store all content under a subdirectory - uids will be relative to this - defaults to nil
			:s3_fog_storage_options,  # hash for passing any extra options to Fog :s3_ :s3_Storage.new, e.g. {path_style :s3_ true}

# Per-storage options
			:s3_storage_path,
			:s3_storage_headers,

#	Custom datastore options
      :custom_backend_class,
      :custom_backend_opts

# other
			:verbose_cache_logging

		self.dragonfly_secret = Array.new(24) { rand(256) }.pack('C*').unpack('H*').first
		self.s3_backend = false
    self.s3_bucket_name = ENV['S3_BUCKET']
    self.s3_region = ENV['S3_REGION']
    self.s3_access_key_id = ENV['S3_KEY']
    self.s3_secret_access_key = ENV['S3_SECRET']
    self.custom_backend_class = false
    self.dragonfly_custom_backend_class = ''
    self.dragonfly_custom_backend_opts = {}
    self.dragonfly_insert_before = 'ActionDispatch::Callbacks'
    self.dragonfly_url_format = '/system/refinery/:job/:basename.:ext'
    self.dragonfly_url_host = ''
    self.dragonfly_url_scheme = 'https'
		self.verbose_cache_logging = false


  # We have to configure these settings after Rails is available.
  # But a non-nil custom option can still be provided
    class << self
      def datastore_root_path
        config.datastore_root_path || (Rails.root.join('public', 'system', 'refinery', 'images').to_s if Rails.root)
      end
    end
  end
end
