require 'spec_helper'

describe  String do
   describe "#singular?" do
      it { "poop".singular?.should == true }
      it {"farts".singular?.should == false}
   end
end