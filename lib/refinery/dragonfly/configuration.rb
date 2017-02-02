module Refinery
  module Dragonfly

    include ActiveSupport::Configurable

    # All dragonfly configuration options allowed
    config_accessor :dragonfly_options, :s3_options, :rackcache_options

    config.dragonfly_options = {
      allow_legacy_urls: false,
      analysers: [],
      before_serve: nil,
      datastore_root_path: 'public/refinery/dragonfly',
      define_url: nil,
      fetch_file_whitelist: nil,
      fetch_url_whitelist: nil,
      first_bytes: nil,
      generators: [],
      insert_before: nil,
      mime_type: nil,
      plugin: :imagemagick,
      processors: [],
      url: nil,
      url_segment: '',
      url_format: '/system/refinery/:job/:basename.:ext',
      url_host: '',
      path_prefix: nil,
      response_header: nil,
      secret: Array.new(24) { rand(256) }.pack('C*').unpack('H*').first,
      verify_urls: true
    }

# s3 Data Store Config
    config.s3_options = {
      s3_backend: false,
      s3_bucket_name: ENV['S3_BUCKET'],
      s3_access_key_id: ENV['S3_KEY'],
      s3_secret_access_key: ENV['S3_SECRET'],
      s3_region: ENV['S3_REGION'], # default 'us-east-1', see Dragonfly S3DataStore :s3_REGIONS for options
      s3_url_scheme: nil, # defaults to "http"
      s3_url_host: nil, # defaults to "<bucket-name>.s3.amazonaws.com", or "s3.amazonaws.com/<bucket-name>" if not a valid subdomain
      s3_use_iam_profile: nil, # boolean - if true, no need for access_key_id or secret_access_key
      s3_root_path: nil, # store all content under a subdirectory - uids will be relative to this - defaults to nil
      s3_fog_storage_options: nil, # hash for passing any extra options to Fog :s3_ :s3_Storage.new, e.g. {path_style :s3_ true}

      # Per-storage options
      s3_storage_path: nil,
      s3_storage_headers: nil,

      #	Custom datastore options
      s3_custom_backend_class: '',
      s3_custom_backend_opts: {},
    }
# other
    config.rackcache_options = {
      verbose_cache_logging: false
    }
  end
end
