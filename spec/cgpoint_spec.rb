describe "CGPoint" do

  describe "== operator" do
    it "returns true for the same point" do
      CGPointMake(-12345, -12345).should == CGPointMake(-12345, -12345)
      CGPointMake(1, 1).should == CGPointMake(1, 1)
    end

    it "returns false for other points" do
      CGPointMake(1, 1).should != CGPointMake(0.999, 0.999)
      CGPointMake(1, 1).should != CGPointZero
    end
  end

  describe "=~ operator" do
    it "should return true if the points are roughly equal" do
      CGPointZero.should =~ CGPointZero
      CGPointZero.should =~ CGPointMake( 0.00001,  0.00001)
      CGPointZero.should =~ CGPointMake(-0.00001, -0.00001)
    end

    it "should return false if the points are not roughly equal" do
      CGPointZero.should.not =~ CGPointMake(1, 1)
    end

    it "should return true if vectors are roughly equal" do
      CGPointZero.should =~ CGSizeZero
      CGPointZero.should =~ CGSizeMake( 0.00001,  0.00001)
      CGPointZero.should =~ CGSizeMake(-0.00001, -0.00001)
    end

    it "should return false if vectors are not roughly equal" do
      CGPointZero.should.not =~ CGSizeMake(1, 1)
    end

    it "should raise if given a wrong type" do
      lambda { CGPointZero =~ "abc" }.should.raise(TypeError)
    end
  end

  describe "unary -" do
    it "returns the point with negative coordinates" do
      (-CGPointMake(1, 1)).should == CGPointMake(-1, -1)
      (-CGPointZero).should == CGPointZero
    end
  end

  describe "- operator" do
    it "returns the subtracted point vectors as point" do
      (CGPointMake(1, 1) - CGPointMake(1, 1)).should == CGPointZero
      (CGPointZero - CGPointMake(1, 1)).should == CGPointMake(-1, -1)
    end

    it "raises if not given a point" do
      lambda { CGPointZero - "abc" }.should.raise(TypeError)
    end
  end

  describe "+ operator" do
    it "returns the added point vectors as point" do
      (CGPointMake(1, 2) + CGPointMake(3, 4)).should == CGPointMake(4, 6)
      (CGPointMake(-1, -2) + CGPointMake(1, 2)).should == CGPointZero
    end

    it "raises if not given a point" do
      lambda { CGPointZero + "abc" }.should.raise(TypeError)
    end
  end

  describe "* operator" do
    it "scales the point if given a Float" do
      (CGPointZero * 23.0).should == CGPointZero
      (CGPointMake(1, 2) * 23.0).should == CGPointMake(23, 46)
      (CGPointMake(1, 2) * -1.0).should == CGPointMake(-1, -2)
    end

    it "scales the point if given a Fixnum" do
      (CGPointZero * 23).should == CGPointZero
      (CGPointMake(1, 2) * 23).should == CGPointMake(23, 46)
      (CGPointMake(1, 2) * -1).should == CGPointMake(-1, -2)
    end

    it "scales the point if given a CGSize" do
      size = CGSizeMake(2, 4)
      (CGPointZero * size).should == CGPointZero
      (CGPointZero * size).should.is_a CGPoint
      (CGPointMake(1, 1) * size).should =~ size
      (CGPointMake(3, 5) * size).should == CGPointMake(6, 20)
    end

    it "scales the point if given a CGPoint" do
      point = CGPointMake(2, 4)
      (CGPointZero * point).should == CGPointZero
      (CGPointZero * point).should.is_a CGPoint
      (CGPointMake(1, 1) * point).should == point
      (CGPointMake(3, 5) * point).should == CGPointMake(6, 20)
    end

    it "applies a transform if given" do
      (CGPointZero * CGAffineTransform.scale(5)).should == CGPointZero
      point = CGPointMake(1, 2)
      (point * CGAffineTransform.scale(5)).should == point * 5
    end

    it "raises if given another type" do
      lambda { CGPointZero * "abc" }.should.raise(TypeError)
    end
  end

  describe "#distance_to(other)" do
    it "returns 0.0 for the same points" do
      (CGPointMake(1, 1).distance_to CGPointMake(1, 1)).should == 0.0
      (CGPointMake(-1234, -1234).distance_to CGPointMake(-1234, -1234)).should == 0.0
    end

    it "returns the absolute distance" do
      (CGPointMake(1, 0).distance_to CGPointZero).should =~ 1.0
      (CGPointMake(0, 1).distance_to CGPointZero).should =~ 1.0
      (CGPointZero.distance_to CGPointMake(1, 0)).should =~ 1.0
      (CGPointZero.distance_to CGPointMake(0, 1)).should =~ 1.0
    end

    it "returns the distance to the given other point as float" do
      (CGPointMake(1, 1).distance_to CGPointZero).should =~ Math.sqrt(2.0)
      (CGPointMake(-1, -1).distance_to CGPointZero).should =~ Math.sqrt(2.0)
    end

    it "raises if given no point" do
      lambda { CGPointZero.distance_to "abc" }.should.raise(TypeError)
    end
  end

  describe '#clamp_to_rect(rect)' do
    it "limits the point coordinates to the given rect" do
      rect = CGRectMake(0, 0, 1, 1)
      CGPointZero.clamp_to_rect(rect).should == CGPointZero
      CGPointMake(1, 1).clamp_to_rect(rect).should == CGPointMake(1, 1)
      CGPointMake(0.5, 0.5).clamp_to_rect(rect).should == CGPointMake(0.5, 0.5)
      CGPointMake(-1, -1).clamp_to_rect(rect).should == CGPointZero
      CGPointMake(2, 2).clamp_to_rect(rect).should == CGPointMake(1, 1)
    end

    it "raises if given no rect" do
      lambda { CGPointZero.clamp_to_rect "abc" }.should.raise(TypeError)
    end
  end

  describe '#round' do
    it "returns the point rounded to next integer coordinates" do
      CGPointMake(0.1, 0.1).round.should == CGPointZero
      CGPointMake(-0.1, -0.1).round.should == CGPointZero
      CGPointMake(12.34, 12.34).round.should == CGPointMake(12, 12)
      CGPointMake(34.56, 34.56).round.should == CGPointMake(35, 35)
    end
  end

  describe '#floor' do
    it "returns the point rounded down to integer coordinates" do
      CGPointMake(0.1, 0.1).floor.should == CGPointZero
      CGPointMake(-0.1, -0.1).floor.should == CGPointMake(-1, -1)
      CGPointMake(12.34, 12.34).floor.should == CGPointMake(12, 12)
      CGPointMake(34.56, 34.56).floor.should == CGPointMake(34, 34)
    end
  end

  # describe "#angle" do
  #   it "should work"
  # end

  describe "#apply(transform)" do
    it "returns a new point with the given transform applied" do
      p = CGPointMake(1, 1)
      scale = CGAffineTransform.scale(2.0, 2.0)
      p = p.apply(scale)
      p.should == CGPointMake(2, 2)
    end

    it "raises if given no transform" do
      lambda { CGPointZero.clamp_to_rect "abc" }.should.raise(TypeError)
    end
  end

  describe "#to_dictionary" do
    it "returns a dictionary" do
      CGPointMake(1, 1).to_dictionary.should.is_a(NSDictionary)
    end
  end

  describe "#to_value" do
    it "returns a correct NSValue" do
      value = CGPointMake(1, 1).to_value
      value.CGPointValue.should == CGPointMake(1, 1)
    end
  end

  describe "#to_size" do
    it "returns a CGSize" do
      size = CGPointMake(1, 2).to_size
      size.should.is_a(CGSize)
      size.should == CGSizeMake(1, 2)
    end
  end

  describe "#to_s" do
    it "should return a sensible string" do
      CGPointMake(23, 42).to_s.should == "{23, 42}"
    end
  end

end
