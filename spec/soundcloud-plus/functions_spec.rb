require 'spec_helper'

describe  String do
   describe "#singular?" do
      it { "mouse".singular?.should == true }
      it { "farts".singular?.should == false}
   end
end