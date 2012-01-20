require 'spec_helper'

describe SoundcloudPlus do 
   PARAMS = {:client_id => "client_id", :site => "example.com", :on_exchange_token => "token"}

   let(:client){SoundcloudPlus.new(PARAMS)}
   describe "#attach" do
      it "should be able attach random to path" do
         client.attach("poopsticks", 1234)
         client.path.should == "/poopsticks/1234"
      end
   end

   describe "#resolve" do
      before(:each){client.should_receive(:get).with("/resolve",:url => "http://example.com/poopman/poopy-track")}
      it{ client.resolve("http://example.com/poopman/poopy-track")}
      it{ client.resolve("poopman/poopy-track")}
      it{ client.resolve("/poopman/poopy-track")}
   end

   describe "#fetch! (and alias)" do
      before(:each){client.should_receive(:get).with("/tracks/1234",PARAMS)}
      it{ client.track(1234).fetch!}
      it{ client.tracks(1234)}
      it{ client.track(1234).get!}
   end

   describe "#me" do
      it "should add /me to path" do
         client.me
         client.path.should == "/me"
      end
      it "should remove other stuff from path when called" do
         client.track(1234).me
         client.path.should == "/me"
      end
   end

   describe "#user" do
      it "should add user with id" do
         client.user(1234)
         client.path.should == "/users/1234"
      end
      it "should add user with permalink only" do
         client.stub!(:resolve).and_return(client)
         client.stub!(:id).and_return(1234)
         client.user("bob")
         client.path.should == "/users/1234"
      end
   end

   describe "#users" do
      it "should request users" do
         client.should_receive(:get).with("/users", PARAMS)
         client.users
      end
   end

   %w(user track playlist group comment app).each do |method|
      describe "##{method}(1234)" do
         it "should add correct thing to path" do
            client.send(method, 1234)
            client.path.should == "/#{method.pluralize}/1234"
         end
      end

      describe "##{method.pluralize}" do
         it "should add list to end of path and fetch" do
            client.should_receive(:get).with("/#{method.pluralize}", PARAMS)
            client.send(method.pluralize)
         end
      end
   end

   %w(shared_to secret_token all own exclusive).each do |method|
      describe "##{method}" do
         it "should add correct thing to path" do
            client.send(method, 1234)
            client.path.should == "/#{method.gsub('_','-')}/1234"
         end
      end
   end

   describe "s ability to chain calls together" do
      it "should chain track and comment together" do
         client.track(1234).comment(5678)
         client.path.should == "/tracks/1234/comments/5678"
      end

   end

   %w(limit order).each do |method|
      it "should add parameter to options" do
         client.send(method,"param")
         client.options[method.to_sym].should == "param"
      end
   end

   describe "#where" do
      it "should add hash to parameters" do
         client.where(:thing => "sweet")
         client.options.should == PARAMS.merge({:thing => "sweet"})
      end
   end

end