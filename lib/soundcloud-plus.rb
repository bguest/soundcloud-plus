
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

   # Add parameters to the query options
   #
   # @example Adding limit to number of user returned
   #   client = SoundcloudPlus.new(:client_id => "client_id")
   #   client.user.where(:limit => 5)
   #
   # @return [SoundcloudPlus] self
   #
   def where(params = {})
      @options.merge!(params)
      self
   end

   # Attaches resource and resource id path
   #
   # @example Attach user resource to path
   #   client = SoundcloudPlus.new(:client_id => "client_id")
   #   client.attach("users", "bob")
   #   client.path  # => /users/1234
   #
   # @return [ SoundcloudPlus ] self 
   #
   def attach(resource, value = nil, options = {})
      @path << "/#{resource}"
      @options.merge!(options)
      if value
         @path << (value.class == Fixnum ? "/#{value}" : "/#{resolve(value).id}" )
      end
      self
   end

   # Fetches resources from current path with current options
   #
   # @example Fetching user
   #   client = SoundcloudPlus.new(:client_id => "client_id")
   #   user = client.user(1234).fetch!
   #   user.permalink # => "bob"
   #
   # @return [Hashie] Hashie containing resource from path
   #
   def fetch!
      old_path = path
      if old_path && path.length > 0
         path = ""
         @results = get(old_path, @options)
      end
   end
   alias :get! :fetch!

   # Finds the soundcloud id for a soundcloud link or path
   #
   # @example Getting id of song with link
   #   client = SoundcloudPlus.new(:client_id => "client_id")
   #   track = client.resolve("http://soundcloud.com/poopyman/poopy-pants-song") 
   #   track.name # => "Poopy Pants Song"
   # 
   # @example Getting id of song with 
   #
   def resolve(path)
      path = URI.parse(path).path.sub(/\A\/+/,'')
      url = "http://#{site}/#{path}"
      @results = get("/resolve", :url => url)
   end

end
