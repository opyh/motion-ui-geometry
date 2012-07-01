describe "CGSize" do

  before do
    @unit_size = CGSizeMake 1, 1
  end

  describe "operators" do
    describe '==' do
      it "returns true for the same size" do
        CGSizeMake(-12345, -12345).should == CGSizeMake(-12345, -12345)
        @unit_size.should == @unit_size
      end

      it "returns false for other sizes" do
        @unit_size.should != CGSizeMake(0.999, 0.999)
        @unit_size.should != CGSizeZero
      end
    end

    describe "=~" do
      it "should return true for a roughly equal size" do
        CGSizeMake(0.00001, 0.00001).should =~ CGSizeZero
        CGSizeMake(-0.00001, -0.00001).should =~ CGSizeZero
      end

      it "should return false for a non-equal size" do
        CGSizeMake(0, 1).should.not =~ CGSizeZero
      end

      it "should return true for a roughly equal point" do
        CGSizeMake(0.00001).should =~ CGSizeZero
        CGSizeMake(-0.00001).should =~ CGSizeZero
      end

      it "should return false for a non-equal point" do
        CGSizeMake(0, 1).should.not =~ CGSizeZero
      end

      it "should raise if given another type" do
        lambda {CGSizeZero =~ "abc"}.should.raise TypeError
      end
    end

    describe "+" do
      it "returns the added size vectors as size if given a size" do
        (@unit_size + @unit_size).should == CGSizeMake(2, 2)
        (CGSizeMake(-1, -1) + @unit_size).should == CGSizeZero
      end

      it "returns the added size vectors as size if given a point" do
        (@unit_size + @unit_size).should == CGSizeMake(2, 2)
        (CGSizeMake(-1, -1) + @unit_size).should == CGSizeZero
      end

      it "should raise if given another type" do
        lambda {CGSizeZero + "abc"}.should.raise TypeError
      end
    end


    describe "binary -" do
      it "returns the subtracted size vectors as size if given a size" do
        (@unit_size - @unit_size).should == CGSizeZero
        (CGSizeZero - @unit_size).should == CGSizeMake(-1, -1)
      end

      it "returns the subtracted size vectors as size if given a point" do
        (@unit_size - CGPointMake(1, 1)).should == CGSizeZero
        (CGSizeZero - CGPointMake(1, 1)).should == -@unit_size
      end

      it "should raise if given another type" do
        lambda {CGSizeZero - "abc"}.should.raise TypeError
      end
    end

    describe "unary -" do
      it "should return the negative size" do
        (-CGSizeMake(1, 2)).should == CGSizeMake(-1, -2)
      end
    end

    describe "*" do
      it "scales the size if given a Float" do
        (@unit_size * 2.0).should == CGSizeMake(2, 2)
      end

      it "scales the size if given a Fixnum" do
        (@unit_size * 2).should == CGSizeMake(2, 2)
      end

      it "scales the size if given a CGSize" do
        (@unit_size * @unit_size).should == @unit_size
        (@unit_size * CGSizeZero).should == CGSizeZero
        (CGSizeMake(1, 2) * CGSizeMake(-0.5, -0.5)).should == CGSizeMake(-0.5, -1)
      end

      it "scales the size if given a CGPoint" do
        (@unit_size * CGPointMake(1, 1)).should == @unit_size
        (@unit_size * CGPointZero).should == CGSizeZero
        (CGSizeMake(1, 2) * CGPointMake(-0.5, -0.5)).should == CGSizeMake(-0.5, -1)
      end

      it "applies a transform if given" do
        size = CGSizeMake(1, 2) * CGAffineTransform.scale(3, 4)
        size.should == CGSizeMake(3, 8)
      end

      it "raises if given another type" do
        lambda { CGSizeZero * "abc" }.should.raise TypeError
      end
    end
  end

  describe '#round' do
    it "returns the size rounded to next integer coordinates" do
      CGSizeMake(0.1, 0.1).round.should == CGSizeZero
      CGSizeMake(-0.1, -0.1).round.should == CGSizeZero
      CGSizeMake(12.34, 12.34).round.should == CGSizeMake(12, 12)
      CGSizeMake(34.56, 34.56).round.should == CGSizeMake(35, 35)
    end
  end

  describe '#floor' do
    it "returns the size rounded down to integer coordinates" do
      CGSizeMake(0.1, 0.1).floor.should == CGSizeZero
      CGSizeMake(-0.1, -0.1).floor.should == CGSizeMake(-1, -1)
      CGSizeMake(12.34, 12.34).floor.should == CGSizeMake(12, 12)
      CGSizeMake(34.56, 34.56).floor.should == CGSizeMake(34, 34)
    end
  end

  describe "#apply(transform)" do
    it "returns a new size with the given transform applied" do
      s = CGSizeMake(1, 2).apply(CGAffineTransform.scale(2.0, 2.0))
      s.should =~ CGSizeMake(2, 4)
    end
  end

  # describe "#angle" do
  #   it "should work"
  # end


  describe "conversion methods" do
    describe "#to_dictionary" do
      it "returns a dictionary" do
        @unit_size.to_dictionary.should.is_a(NSDictionary)
      end
    end

    describe "#to_value" do
      it "returns correct NSValue" do
        value = @unit_size.to_value
        value.CGSizeValue.should == @unit_size
      end
    end

    describe "#to_rect" do
      it "returns a CGRect" do
        rect = CGSizeMake(1, 2).to_rect
        rect.should.is_a(CGRect)
        rect.should == CGRectMake(0, 0, 1, 2)
      end
    end

    describe "#to_s" do
      it "should return a sensible string" do
        CGSizeMake(23, 42).to_s.should == "{23, 42}"
      end
    end
  end

end
