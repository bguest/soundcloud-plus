About
=====

SoundcloudPlus is a lightweight wrapper for a lightweight wrapper for the Soundcloud web API. 

The official soundcloud gem is pretty bare bones. This builds on top of the the soundclout gem and makes things a little more ruby. It doesn't do much that the soundcloud gem won't do, but it does it in a slightly nicer way.

Instead of 

    client = Soundcloud.new(:client_id => "123456789")
    client.get("/users/1234/comments", :limit => 5)
    
You can do

    client = SoundcloudPlus.new(:client_id => "123456789")
    client.user(1234).comment.limit(5)
    or
    client.user(1234).comments(:limit => 5)

Like all abstractions this one is a little leaky so it helps to know what is going on under the hood. If nothing else, remember that the plurality of the method count.

## Singular methods add resources to the api fetch path

For example:

    client = SoundcloudPlus.new(:client_id => "123456789")
    client.track(1234).shared_to.email 
    client.path # => "/tracks/1234/shared-to/emails"
   
This path must match the soundcloud web api. You can't do something like

    client.user(1234).comment(4321).track(2345) # Won't work
   
## Plural methods add resources to the api path and then fetch

For example

    client = SoundcloudPlus.new(:client_id => "123456789")
    client.user(1234).favorites # => Array of user 1234's favorites
    or
    client.users(1234) # => Hashie with user 1234's information

## Calls to resource properties will also result in a one time fetch

For example

    client = SoundcloudPlus.new(:client_id => "123456789")
    track  = client.track(1234) # => SoundcloudPlus object with path = "/tracks/1234"
    track.id  # Makes fetch to "/tracks/1234", returns "1234" 
              # Subsequent property calls don't result in a fetch.

