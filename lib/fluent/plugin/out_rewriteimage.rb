require 'base64'
require 'open-uri'

module Fluent
  class Fluent::RewriteImageOutput < Fluent::Output
    include Fluent::HandleTagNameMixin

    Fluent::Plugin.register_output('rewriteimage', self)

    def initialize
      super
    end

    config_param :image_source_key, :string
    config_param :image_key, :string
    config_param :base64encode, :bool

    def configure(conf)
      super

      if (
          !remove_tag_prefix &&
          !remove_tag_suffix &&
          !add_tag_prefix    &&
          !add_tag_suffix
      )
        raise ConfigError, "out_rewriteimage: At least one of remove_tag_prefix/remove_tag_suffix/add_tag_prefix/add_tag_suffix is required to be set."
      end
    end

    def start
      super

    end

    def shutdown
      super

    end

    def emit(tag, es, chain)
      es.each {|time,record|
        t = tag.dup
        filter_record(t, time, record)
        Engine.emit(t, time, record)
      }

      chain.next
    end

    def filter_record(tag, time, record)
      raw_media = open(record[@image_source_key], 'rb').read
        
      record[@image_key] = @base64encode ? Base64.encode64(raw_media) : raw_media

      super(tag, time, record)
    end

  end
end
