describe NSString do
  describe "#to_point" do
    it "should return a point" do
      "{1, 2}".to_point.should == CGPointMake(1, 2)
      "{1, 2, 3}".to_point.should == CGPointMake(1, 2)
    end

    it "should return CGPointZero if in wrong format" do
      "{1, 2, 3".to_point.should == CGPointZero
    end
  end

  describe "#to_size" do
    it "should return a size" do
      "{1, 2}".to_size.should == CGSizeMake(1, 2)
      "{1, 2, 3}".to_size.should == CGSizeMake(1, 2)
    end

    it "should return CGSizeZero if in wrong format" do
      "{1, 2, 3".to_size.should == CGSizeZero
    end
  end

  describe "#to_rect" do
    it "should return a rect" do
      "{{1, 2}, {3, 4}}".to_rect.should == CGRectMake(1, 2, 3, 4)
      "{{1,2},{3,4}}".to_rect.should == CGRectMake(1, 2, 3, 4)
      "{{1,2},{3,4},{5,6}}".to_rect.should == CGRectMake(1, 2, 3, 4)
    end
    it "should return CGRectZero if in wrong format" do
      "{1, 2, 3".to_rect.should == CGRectZero
    end
  end

  describe "#to_affine_transform" do
    it "should return a transform" do
      "[1,2,3,4,5,6]".to_transform.should == CGAffineTransformMake(1, 2, 3, 4, 5, 6)
      "[1,2, 3,4, 5,6]".to_transform.should == CGAffineTransformMake(1, 2, 3, 4, 5, 6)
    end
  end

end