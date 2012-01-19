
require 'soundcloud'
require 'soundcloud-plus/functions'
require 'uri'

class SoundcloudPlus < Soundcloud

   attr_accessor :path , :options

   PLURAL_CALLS   = %w(user track playlist group comment connection activity app following follower favorite favoriter email)
   SINGULAR_CALLS = %w(shared-to secret-token all own affiliated exclusive)
   PARAMETERS =     %w(limit order)

   def initialize(options={})
      super options
      @path = ""
   end

   # Call method on fetched results
   def method_missing(method, *args, &block)
      @results ||= self.fetch!
      @results.send(method)
   end

   def me
      @path = "/me"
   end

   # Tally look up methods
   SINGULAR_CALLS.each do |call|
      class_eval <<-METHOD
         def #{call.gsub('-','_')}(value, options = {})
            attach("#{call}",value, options)
         end
      METHOD
   end

   PLURAL_CALLS.each do |call|
      class_eval <<-METHOD
         def #{call.pluralize}(value = nil, options = {})
            attach("#{call.pluralize}", value, options).fetch!
         end

         def #{call}(value = nil, options = {})
            attach("#{call.pluralize}", value, options)
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

   def attach(method, value = nil, options = {})
      @path << "/#{method}"
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
         @results = get(old_path, @options)
      end
   end

   #
   def resolve(path)
      path = URI.parse(path).path.sub(/\A\/+/,'')
      url = "http://#{site}/#{path}"
      get("/resolve", :url => url)
   end

end
