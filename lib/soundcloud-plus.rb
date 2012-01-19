
require 'soundcloud'
require 'soundcloud-plus/functions'
require 'uri'

class SoundcloudPlus < Soundcloud

   attr_accessor :path, :options

   SINGULAR_CALLS = %w(shared-to secret-token all own affiliated exclusive)
   PARAMETERS =     %w(limit order)

   def initialize(options={})
      super options
      @path = ""
      @option = {}
   end

   # Catch all for missing api calls 
   def method_missing(method, *args, &block)
      if ! block 
         call = method.to_s
         plural = call.pluralize
         if call.singular? || args[0]
            return (args[1] ? attach(plural, args[0], args[1]) : attach(plural, args[0]))
         else
            return attach(plural).fetch!
         end
      end
      raise NoMethodError
   end

   def me
      @path = "/me"
   end

   # Tally look up methods
   SINGULAR_CALLS.each do |call|
      class_eval <<-METHOD
         def #{call.gsub('-','_')}(value, options = {})
            attach("#{call}",value)
         end
      METHOD
   end

   PARAMETERS.each do |call|
      class_eval <<-METHOD
         def #{call}(value)
            if value
               @options[:#{call}] = value 
               self
            else
               @options[:#{call}]
            end
         end
      METHOD
   end

   def attach(call, value = nil, options = {})
      @path << "/#{call}"
      @options.merge!(options)
      if value
         @path << (value.class == Fixnum ? "/#{value}" : "/#{resolve(value)}" )
      end
      self
   end

   def fetch!
      old_path = path
      if old_path
         path = ""
         get(old_path, @options)
      end
   end

   #
   def resolve(path)
      path = URI.parse(path).path.sub(/^\/+/,'')
      url = "http://#{site}/#{path}"
      get("/resolve", :url => url)
   end

end
