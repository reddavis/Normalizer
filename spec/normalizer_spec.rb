require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Normalizer" do
   
  describe "Normalization" do
    it "should be 0.5" do
      a = Normalizer.new(:min => [0], :max => [10])
      results = a.normalize([5])
      results[0].should == 0.5
    end

    describe "Going over/under max/min" do
      before(:all) do
        @a = Normalizer.new(:min => [0], :max => [10])
      end
      
      it "should return true" do
        results = @a.normalize([20])
        @a.breaks_boundary?.should be_true
      end
      
      it "should return false" do
        results = @a.normalize([2])
        @a.breaks_boundary?.should be_false
      end
    end
  end
 
  describe "Finding Max and Min" do
    describe "With 0 Standard deviation" do
      before(:all) do
        data = [[0, 1, 2, 3, 4], [10, 11, 12, 13, 14]]
        @a = Normalizer.find_min_and_max(data)
      end
      
      it "should return 10,11,12,13,14 for max" do
        @a[1].should == [10, 11, 12, 13, 14]
      end
      
      it "should return 0,1,2,3,4 for min" do
        @a[0].should == [0, 1, 2, 3, 4]
      end
    end
    
    describe "With 3 Standard deviation" do
      before(:all) do
        data = [[0, 0, 0, 0, 0], [10, 10, 10, 10, 10]]
        @a = Normalizer.find_min_and_max(data, :std => 3)
      end
      
      it "should return std for max" do
        std = (Math.sqrt(50) * 3) + 10.0
        @a[1][0].should == std
      end
      
      it "should return std for min" do
        std = 0.0 - (Math.sqrt(50) * 3)
        @a[0][0].should == std
      end
    end
  end
  
end
