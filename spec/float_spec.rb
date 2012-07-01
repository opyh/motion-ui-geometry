describe "Float" do

  describe "#clamp" do
    it "works with a [-1,1] range" do
      -1.0.clamp(-1, 1).should == -1
       0.0.clamp(-1, 1).should ==  0
       1.0.clamp(-1, 1).should ==  1
      -2.0.clamp(-1, 1).should == -1
       2.0.clamp(-1, 1).should ==  1
      -1.0.clamp(1, -1).should == -1
       0.0.clamp(1, -1).should ==  0
       1.0.clamp(1, -1).should ==  1
      -2.0.clamp(1, -1).should == -1
       2.0.clamp(1, -1).should ==  1
    end

    it "works with a [0, 100] range" do
      42.0.clamp(0, 100).should == 42
      1337.0.clamp(0, 100).should == 100
      -123.0.clamp(0, 100).should == 0
      42.0.clamp(100, 0).should == 42
      1337.0.clamp(100, 0).should == 100
      -123.0.clamp(100, 0).should == 0
    end

    it "works with a [0, 0] range" do
      42.0.clamp(0, 0).should == 0
      1337.0.clamp(0, 0).should == 0
      -123.0.clamp(0, 0).should == 0
    end

    it "works with floats" do
      -1.0001.clamp(-1, 1).should == -1
      1.0001.clamp(-1, 1).should == 1
      -1.0001.clamp(1, -1).should == -1
      1.0001.clamp(1, -1).should == 1
    end

    it "raises an error if given a string" do
      lambda {0.0.clamp("123", 0)}.should.raise(TypeError)
      lambda {0.0.clamp(0, "123")}.should.raise(TypeError)
    end
  end

  describe "#roughly_equal" do
    it "returns true for the same value" do
      1.0.should.roughly_equal(1.0, 0.0)
      -1.0.should.roughly_equal(-1.0, 0.0)
    end

    it "returns true for values within the given epsilon limit" do
      1.0.should.roughly_equal(1.00001, 0.00002)
      1.0.should.roughly_equal(0.99999, 0.00002)
      1.0.should.roughly_equal(0.9999999)
    end

    it "returns false for values outside the given epsilon limit" do
      1.0.should.not.roughly_equal(1.1, 0.001)
      -1.0.should.not.roughly_equal(-1.1, 0.001)
      -1.0.should.not.roughly_equal(-1.1)
    end
  end

  describe "=~" do
    it "behaves like roughly_equal with epsilon == 0.0001" do
      1.0.should =~ 1.0000001
      1.0.should.not =~ 1.001
    end
  end

  describe "#to_radians, #to_degrees" do
    it "is mathematically correct for example values" do
      -180.0.to_radians.should == -Math::PI
      0.0.to_radians.should == 0
      180.0.to_radians.should == Math::PI
      360.0.to_radians.should == 2.0 * Math::PI

      -180.0.to_radians.should == -Math::PI
      0.0.to_radians.should == 0
      180.0.to_radians.should == Math::PI
      360.0.to_radians.should == 2 * Math::PI

      -Math::PI.to_degrees.should == -180
      0.0.to_degrees.should == 0.0
      Math::PI.to_degrees.should == 180
      (2 * Math::PI).to_degrees.should == 360.0
    end

    it "returns the initial value if reverse-applied" do
      1.0.to_radians.to_degrees.should =~ 1.0
      1.0.to_degrees.to_radians.should =~ 1.0

      Math::PI.to_degrees.to_radians.should =~ Math::PI
      180.0.to_radians.to_degrees.should =~ 180.0
    end
  end

  describe "#to_value" do
    it "should return an NSNumber" do
      value = 12.34.to_value
      value.should.is_a NSNumber
      value.floatValue.should == 12.34
    end
  end


end
