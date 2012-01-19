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

   describe ".resolve" do
      before(:each){client.should_receive(:get).with("/resolve",:url => "http://example.com/poopman/poopy-track")}
      it{ client.resolve("http://example.com/poopman/poopy-track")}
      it{ client.resolve("poopman/poopy-track")}
      it{ client.resolve("/poopman/poopy-track")}
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
         client.stub!(:resolve).and_return(5432)
         client.user("bob")
         client.path.should == "/users/5432"
      end
   end

   describe "#users" do
      it "should request users" do
         client.should_receive(:get).with("/users", PARAMS)
         client.users
      end
   end

   describe "#bogus_call" do
      it "should add 'bogus_call' to path" do
         client.user(1234).bogus_call
         client.path.should == "/users/1234/bogus_calls"
      end
      it "should fetch after non-singular call" do
         client.should_receive(:get).with("/users/1234/bogus_calls", PARAMS)
         client.user(1234).bogus_calls
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

   %w(shared_to).each do |method|
      describe "##{method}" do
         it "should add correct thing to path" do
            client.send(method, 1234)
            client.path.should == "/shared-to/1234"
         end
      end
   end


   describe "s ability to chain calls together" do
      it "should chain track and comment together" do
         client.track(1234).comment(5678)
         client.path.should == "/tracks/1234/comments/5678"
      end

   end

end