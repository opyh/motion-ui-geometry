describe "CGRect" do
  before do
    @unit_rect = CGRectMake(0, 0, 1, 1)
  end

  describe "Operators" do
    describe '==' do
      it "returns true for the same rect" do
        CGRectMake(-1, -2, -3, -4).should == CGRectMake(-1, -2, -3, -4)
        CGRectMake(1, 2, 3, 4).should == CGRectMake(1, 2, 3, 4)
      end

      it "returns false for other rects" do
        rect = CGRectMake(1, 1, 1, 1)
        rect.should != CGRectMake(0.999, 0.999, 0.999, 0.999)
        rect.should != CGRectMake(1, 1, 1, 2)
      end

      it "returns false for other classes" do
        CGRectZero.should != "abc"
      end
    end

    describe "=~" do
      it "returns true for a roughly equal rect" do
        rect = CGRectMake(1, 1, 1, 1)
        rect.should =~ CGRectMake(0.999999, 0.999999, 0.999999, 0.999999)
        rect.should =~ CGRectMake(1.000001, 1.000001, 1.000001, 1.000001)
      end

      it "returns false for a non-equal rect" do
        CGRectMake(1, 1, 1, 1).should.not =~ CGRectMake(1, 2, 3, 4)
      end

      it "raises if given no rect to compare" do
        lambda { CGRectZero =~ "abc" }.should.raise TypeError
      end
    end

    describe "roughly_equal?(other, epsilon)" do
      it "returns true for a roughly equal rect" do
        rect = CGRectMake 1, 1, 1, 1
        rect.should.roughly_equal CGRectMake(0.99, 0.99, 0.99, 0.99), 0.1
        rect.should.roughly_equal CGRectMake(1.01, 1.01, 1.01, 1.01), 0.1
      end

      it "returns false for a non-equal rect" do
        CGRectMake(1, 1, 1, 1).should.not.roughly_equal CGRectMake(1, 2, 3, 4), 0.1
      end

      it "raises if given no rect to compare" do
        lambda { CGRectZero.roughly_equal? "abc" }.should.raise TypeError
      end
    end

    describe "+" do
      it "translates if given a point" do
        (@unit_rect + CGPointMake(3, 4)).should == CGRectMake(3, 4, 1, 1)
      end

      it "resizes if given a size" do
        (@unit_rect + CGSizeMake(3, 4)).should == CGRectMake(0, 0, 4, 5)
      end

      it "raises if given another type" do
        lambda { @unit_rect + "abc" }.should.raise TypeError
      end
    end

    describe "*" do
      before do
        @rect = CGRectMake(-1, -1, 1, 1)
      end
      it "scales the rect if given a Float" do
        (@rect * 5.0).should == CGRectMake(-5, -5, 5, 5)
        (@rect * 0.0).should == CGRectZero
        (@rect * 1.0).should == @rect
      end

      it "scales the rect if given a Fixnum" do
        (@rect * 5).should == CGRectMake(-5, -5, 5, 5)
        (@rect * 0).should == CGRectZero
        (@rect * 1).should == @rect
      end

      it "applies a transform if given" do
        t = CGAffineTransform.scale(5.0)
        CGRectMake(-1, -1, 1, 1)
        (@rect * t).should == (@rect * 5)
      end

      it "raises if given another type" do
        lambda { @rect * "asd" }.should.raise TypeError
      end
    end

    describe "&" do
      it "intersects rects" do
        (@unit_rect & CGRectMake(0.5, 0.5, 1, 1)).
          should == CGRectMake(0.5, 0.5, 0.5, 0.5)
      end

      it "raises if given no rect to intersect" do
        lambda { CGRectZero & "abc" }.should.raise TypeError
      end
    end

    describe "|" do
      it "unionizes rects" do
         (@unit_rect | CGRectMake(1, 1, 2, 2)).should == CGRectMake(0, 0, 3, 3)
      end

      it "raises if given something else" do
        lambda { @unit_rect | "abc" }.should.raise TypeError
      end
    end
  end

  describe "initialize(origin, size)" do
    it "should work if given an origin an a size" do
      origin = CGPointMake(1, 2)
      size = CGSizeMake(3, 4)
      rect = CGRect.new origin, size
      rect.should == CGRectMake(1, 2, 3, 4)
    end

    it "raises if given no correct origin" do
      lambda { CGRect.new "abc", CGSizeZero }.should.raise TypeError
    end

    it "raises if not given a correct size" do
      lambda { CGRect.new CGPointZero, "abc"}.should.raise TypeError
    end
  end

  describe '#round' do
    it "returns the rect with points rounded to next integer coordinates" do
      CGRectMake(0.1, 0.1, 0.1, 0.1).round.should == CGRectZero
      CGRectMake(-0.1, -0.1, -0.1, -0.1).round.should == CGRectZero
      CGRectMake(12.34, 12.34, 12.34, 12.34).round.should == CGRectMake(12, 12, 12, 12)
      CGRectMake(34.56, 34.56, 34.56, 34.56).round.should == CGRectMake(35, 35, 35, 35)
    end
  end

  describe '#floor' do
    it "returns the rect with points rounded down to integer coordinates" do
      CGRectMake(0.1, 0.1, 0.1, 0.1).floor.should == CGRectZero
      CGRectMake(-0.1, -0.1, -0.1, -0.1).floor.should == CGRectMake(-1, -1, -1, -1)
      CGRectMake(12.34, 12.34, 12.34, 12.34).floor.should == CGRectMake(12, 12, 12, 12)
      CGRectMake(34.56, 34.56, 34.56, 34.56).floor.should == CGRectMake(34, 34, 34, 34)
    end
  end

  describe "#center" do
    it "should return the center point" do
      CGRectMake(0, 1, 2, 3).center.should == CGPointMake(1, 2.5)
    end
  end

  describe "#top_left" do
    it "should return the top left corner point" do
      CGRectMake(0, 1, 2, 3).top_left.should == CGPointMake(0, 1)
    end
  end

  describe "#bottom_left" do
    it "should return the bottom left corner point" do
      CGRectMake(0, 1, 2, 3).bottom_left.should == CGPointMake(0, 4)
    end
  end

  describe "#bottom_right" do
    it "should return the top right corner point" do
      CGRectMake(0, 1, 2, 3).bottom_right.should == CGPointMake(2, 4)
    end
  end

  describe "#top_right" do
    it "should return the top right corner point" do
      CGRectMake(0, 1, 2, 3).top_right.should == CGPointMake(2, 1)
    end
  end

  # describe "#angle" do
  #   it "should return the top-left bottom-right diagonal's angle" do
  #   end
  # end

  describe "#divide(amount, edge)" do
    it "returns two rects divided from left if no edge given" do
      rect1, rect2 = @unit_rect.divide(0.2)
      rect1.should == CGRectMake(0, 0, 0.2, 1)
      rect2.should == CGRectMake(0.2, 0, 0.8, 1)
    end

    describe "edges" do
      it "returns correct rects when edge == :right" do
        rect1, rect2 = @unit_rect.divide(0.2, :right)
        rect1.should == CGRectMake(0.8, 0, 0.2, 1)
        rect2.should == CGRectMake(0, 0, 0.8, 1)
      end

      it "returns correct rects when edge == :left" do
        rect1, rect2 = @unit_rect.divide(0.2, :left)
        rect1.should == CGRectMake(0, 0, 0.2, 1)
        rect2.should == CGRectMake(0.2, 0, 0.8, 1)
      end

      it "returns correct rects when edge == :top" do
        rect1, rect2 = @unit_rect.divide(0.2, :top)
        rect1.should == CGRectMake(0, 0, 1, 0.2)
        rect2.should == CGRectMake(0, 0.2, 1, 0.8)
      end

      it "returns correct rects when edge == :bottom" do
        rect1, rect2 = @unit_rect.divide(0.2, :bottom)
        rect1.should == CGRectMake(0, 0.8, 1, 0.2)
        rect2.should == CGRectMake(0, 0, 1, 0.8)
      end
    end
  end

  describe "#inset(dx, dy)" do
    it "returns an inset rect with correct coordinates" do
      @unit_rect.inset(0.1, 0.2).should == CGRectMake(0.1, 0.2, 0.8, 0.6)
    end
  end

  describe "#union(rect)" do
    it "returns the union of both rects" do
      @unit_rect.union(CGRectMake(1, 1, 2, 2)).
        should == CGRectMake(0, 0, 3, 3)
    end
  end

  describe "#intersection(rect)" do
    it "raises if not given a rect" do
      lambda { @unit_rect.intersection("abc") }.
        should.raise(TypeError)
    end

    it "returns the intersection of both rects" do
      @unit_rect.intersection(CGRectMake(0.5, 0.5, 1, 1)).
        should == CGRectMake(0.5, 0.5, 0.5, 0.5)
    end
  end

  describe "#contain?([point|rect])" do
    it "raises if given parameter is no point or rect" do
      lambda { @unit_rect.contain?("abc") }.should.raise(TypeError)
    end

    it "returns true if point is inside" do
      @unit_rect.should.contain(CGPointMake(0.2, 0.6))
    end

    it "returns false if point is outside" do
      @unit_rect.should.not.contain(CGPointMake(-1.5, 2))
    end

    it "returns true if rect is inside" do
      @unit_rect.should.contain(CGRectMake(0.2, 0, 0.5, 0.8))
    end

    it "returns false if rect is outside" do
      @unit_rect.should.not.contain(CGRectMake(1.2, 0, 0.5, 0.8))
    end

    it "returns false if rect only intersects" do
      @unit_rect.should.not.contain(CGRectMake(0.2, 0, 0.5, 1.8))
    end
  end

  describe "#intersects?(rect)" do
    it "returns true for intersecting rects" do
      @unit_rect.should.intersect(CGRectMake(-0.5, -0.5, 1, 1))
      CGRectMake(-0.9, -0.9, 1, 1).should.intersect(CGRectMake(0.0, 0.0, 1, 1))
      CGRectMake(0.999, 0.999, 1, 1).should.intersect(CGRectMake(0.0, 0.0, 1, 1))
    end

    it "returns false for non-intersecting rects" do
      @unit_rect.should.not.intersect(CGRectMake(-1.5, -1.5, 1, 1))
      CGRectMake(1, 1, 1, 1).should.not.intersect(CGRectMake(-0.1, -0.1, 1, 1))
      CGRectMake(-1, -1, 1, 1).should.not.intersect(CGRectMake(0.1, 0.1, 1, 1))
      CGRectMake(-1, -1, 1, 1).should.not.intersect(CGRectMake(0.1, 0.1, 1, 1))
    end
  end

  describe "#empty?" do
    it "returns true for an empty rect" do
      CGRectMake(0, 0, 0, 0).should.be.empty
      CGRectMake(-1, 42, 0, 0).should.be.empty
      CGRectMake(0, 0, 0.1, 0).should.be.empty
      CGRectMake(0, 0, 0, 0.1).should.be.empty
    end

    it "returns false for a non-empty rect" do
      CGRectMake(-1, 42, 0.0001, 0.1).should.not.be.empty
      CGRectMake(-1, 42, 3, 0.1).should.not.be.empty
    end
  end

  describe "#null?" do
    it "returns true for the null rect" do
      CGRectNull.should.be.null
    end

    it "returns false for other rects" do
      CGRectZero.should.not.be.null
      @unit_rect.should.not.be.null
    end
  end

  describe "#apply(transform)" do
    it "returns a new rect with the given transform applied" do
      r = CGRectMake(1, 1, 1, 1).apply(CGAffineTransform.scale(2.0, 2.0))
      r.should =~ CGRectMake(2, 2, 2, 2)
    end
  end

  # TODO: Fix this
  #
  # describe "#infinite?" do
  #   it "returns true for an infinite rect" do
  #     CGRectInfinite.should.be.infinite
  #   end
  #
  #   it "returns false for a non-infinite rect" do
  #     @unit_rect.should.not.be.infinite
  #   end
  # end

  describe "#to_dictionary" do
    it "returns a dictionary" do
      @unit_rect.to_dictionary.should.is_a(NSDictionary)
    end
  end

  describe "#to_value" do
    it "returns correct NSValue" do
      value = @unit_rect.to_value
      value.CGRectValue.should == @unit_rect
    end
  end

  describe "#to_s" do
    it "should return a sensible string" do
      CGRectMake(1, 2, 3, 4).to_s.should == "{{1, 2}, {3, 4}}"
    end
  end

end
