require 'base64'
require 'open-uri'

module Fluent
  class Fluent::RewriteImageOutput < Fluent::Output
    Fluent::Plugin.register_output('rewriteimage', self)

    def initialize
      super
    end

    config_param :remove_prefix,   :string, :default => nil
    config_param :add_prefix,      :string, :default => nil

    config_param :image_source_key, :string
    config_param :image_key, :string
    config_param :base64encode, :bool

    def configure(conf)
      super

      if @remove_prefix
        @removed_prefix_string = @remove_prefix + '.'
        @removed_length = @removed_prefix_string.length
      end
      if @add_prefix
        @added_prefix_string = @add_prefix + '.'
      end
    end

    def start
      super

    end

    def shutdown
      super

    end

    def emit(tag, es, chain)
      if @remove_prefix and
          ((tag.start_with?(@removed_prefix_string) && tag.length > @removed_length) || tag == @remove_prefix)
        tag = tag[@removed_length..-1] || ''
      end

      if @add_prefix
        tag = tag && tag.length > 0 ? @added_prefix_string + tag : @add_prefix
      end

      es.each {|time,record|
        raw_media = open(record[@image_source_key]).read
        
        record[@image_key] = if @base64encoded
          Base64.decode64(raw_media) 
        else
          raw_media
        end

        Engine.emit(tag, time, record)
      }

      chain.next
    end
  end
end
