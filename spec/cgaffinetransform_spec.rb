describe CGAffineTransform do

  before do
    @t = CGAffineTransform.new 1, 2, 3, 4, 5, 6
    @double_scale = CGAffineTransform.new 2, 0, 0, 2, 0, 0
    @double_t = CGAffineTransform.new 2, 4, 6, 8, 10, 12
  end


  describe "#initialize(a, b, c, d, tx, ty)" do
    it "initializes an affine transform" do
      t = CGAffineTransform.new 1, 2, 3, 4, 5, 6
      t.should.is_a(CGAffineTransform)
      t.a.should  == 1
      t.b.should  == 2
      t.c.should  == 3
      t.d.should  == 4
      t.tx.should == 5
      t.ty.should == 6
    end
  end


  describe "Factory methods" do

    describe ".identity" do
      it "returns the identity transform" do
        CGAffineTransform.identity.should == CGAffineTransformIdentity
        CGAffineTransform.identity.should.is_a(CGAffineTransform)
      end
    end

    describe ".rotation(angle_in_rad)" do
      it "creates a rotation transform" do
        t = CGAffineTransform.rotation(Math::PI)
        t.should =~ CGAffineTransform.new(-1, 0, 0, -1, 0, 0)
      end
    end

    describe ".scale(sx, sy)" do
      it "creates a scale transform" do
        t = CGAffineTransform.scale(2, 3)
        t.should.is_a(CGAffineTransform)
        t.should == CGAffineTransform.new(2, 0, 0, 3, 0, 0)
      end

      it "works with only one parameter" do
        t = CGAffineTransform.scale(2)
        t.should.is_a(CGAffineTransform)
        t.should == CGAffineTransform.new(2, 0, 0, 2, 0, 0)
      end
    end

    describe ".translation(tx, ty)" do
      it "creates a translation transform" do
        t = CGAffineTransform.translation(4, 5)
        t.should.is_a(CGAffineTransform)
        t.should == CGAffineTransform.new(1, 0, 0, 1, 4, 5)
      end
    end

    describe ".skew(sx, sy)" do
      it "creates a skew transform" do
        skew = CGAffineTransform.skew(4, 5)
        skew.should.is_a(CGAffineTransform)
        skew.should == CGAffineTransformMake(1, 5, 4, 1, 0, 0)
      end
    end

  end


  describe "Comparison operators" do

    describe "==" do
      it "returns true when equal" do
        CGAffineTransformIdentity.should == CGAffineTransformIdentity
        CGAffineTransformIdentity.should == CGAffineTransform.new(1, 0, 0, 1, 0, 0)
      end

      it "returns false when not equal" do
        CGAffineTransformIdentity.should != CGAffineTransform.new(1, 1, 1, 1, 1, 1)
      end
    end

    describe "=~" do
      before do
        @t1 = CGAffineTransform.new  1, 1, 1, 1, 1, 1
        @t2 = CGAffineTransform.new  0.999999, 0.999999, 0.999999, 0.999999, 0.999999, 0.999999
        @t3 = CGAffineTransform.new  1.0000001, 1.0000001, 1.0000001, 1.0000001, 1.0000001, 1.0000001
        @t4 = CGAffineTransform.new -1.0000001, 1.0000001, 1.0000001, 1.0000001, 1.0000001, 1.0000001
      end

      it "returns true if transforms are roughly equal" do
        @t1.should =~ @t1
        @t1.should =~ @t2
        @t2.should =~ @t3
      end

      it "returns false if transforms are not roughly equal" do
        @t1.should.not =~ @t4
        @t2.should.not =~ @t4
        @t3.should.not =~ @t4
      end
    end

  end


  describe "Applying transforms on other transforms" do

    describe "#concat(other)" do
      it "returns the result of applying the other transform on self" do
        @t.concat(CGAffineTransformIdentity).should == @t
        CGAffineTransformIdentity.concat(@t).should == @t
        @t.concat(@double_scale).should == @double_t
      end
    end

    describe "#apply_on(other)" do
      it "behaves reverse to concat" do
        CGAffineTransformIdentity.apply_on(@t).should == @t
        @t.apply_on(CGAffineTransformIdentity).should == @t
        @double_scale.apply_on(@t).should == @double_t
      end
    end

    describe "via operators" do

      describe "+" do
        it "translates if given a CGSize" do
          t = CGAffineTransformIdentity + CGSizeMake(2, 3)
          t.should == CGAffineTransform.translation(2, 3)
        end

        it "translates if given a CGPoint" do
          t = CGAffineTransformIdentity + CGPointMake(2, 3)
          t.should == CGAffineTransform.translation(2, 3)
        end

        it "raises if given another type" do
          lambda { CGAffineTransformIdentity + "abc" }.should.raise TypeError
        end
      end

      describe "-" do
        it "translates if given a CGSize" do
          t = CGAffineTransformIdentity - CGSizeMake(2, 3)
          t.should == CGAffineTransform.translation(-2, -3)
        end

        it "translates if given a CGPoint" do
          t = CGAffineTransformIdentity - CGPointMake(2, 3)
          t.should == CGAffineTransform.translation(-2, -3)
        end
      end

      describe "unary -" do
        it "inverts the transform" do
          (-CGAffineTransform.identity).should == CGAffineTransform.identity
          (-CGAffineTransform.scale(2, 4)).should == CGAffineTransform.scale(0.5, 0.25)
          (-CGAffineTransform.rotation(20)).should =~ CGAffineTransform.rotation(-20)
          (-CGAffineTransform.translation(2, 4)).should == CGAffineTransform.translation(-2, -4)
        end
      end

      describe "*" do
        it "behaves like #concat if given a transform" do
          @t.concat(CGAffineTransformIdentity).should == @t
          CGAffineTransformIdentity.concat(@t).should == @t
          @t.concat(@double_scale).should == @double_t
        end

        it "scales the transform if given a Float" do
          (CGAffineTransformIdentity * 23.0).should =~ CGAffineTransform.scale(23.0, 23.0)
        end

        it "scales the transform if given a Fixnum" do
          (CGAffineTransformIdentity * 5).should =~ CGAffineTransform.scale(5.0, 5.0)
        end

        it "raises if given another type" do
          lambda { CGAffineTransformIdentity * "abc" }.should.raise TypeError
        end
      end

    end

    describe "via shortcut methods" do

      describe "#translate(tx, ty)" do
        it "translates the transform by an offset of (tx, ty)" do
          t = CGAffineTransform.identity.translate(4, 5)
          t.should == CGAffineTransform.translation(4, 5)
          t.should == CGAffineTransform.new(1, 0, 0, 1, 4, 5)
        end
      end

      describe "#scale(sx, sy)" do
        it "scales the transform by a factor of (sx, sy)" do
          t = CGAffineTransform.identity.scale(23, 42)
          t.should == CGAffineTransform.scale(23, 42)
          t.should == CGAffineTransform.new(23, 0, 0, 42, 0, 0)
        end

        it "works with only one parameter" do
          t = CGAffineTransform.identity
          t.should.is_a(CGAffineTransform)
          t.scale(2).should == CGAffineTransform.new(2, 0, 0, 2, 0, 0)
        end
      end

      describe "#rotate(angle_in_rad)" do
        it "rotates the transform by given angle" do
          t = CGAffineTransform.identity.rotate(Math::PI)
          t.should    == CGAffineTransform.rotation(Math::PI)
          t.a.should  == -1
          t.b.should  =~  0
          t.c.should  =~  0
          t.d.should  == -1
          t.tx.should ==  0
          t.ty.should ==  0
        end
      end

      describe "#skew(sx, sy)" do
        it "skew the transform by given offsets" do
          t = CGAffineTransform.identity.skew(3, 4)
          t.should == CGAffineTransform.skew(3, 4)
          t.should == CGAffineTransform.new(1, 4, 3, 1, 0, 0)
        end
      end

    end

  end

  describe "#invert" do
    it "inverts the transform" do
      i = CGAffineTransform.identity
      i.invert.should == i
      CGAffineTransform.scale(2, 4).invert.should == CGAffineTransform.scale(0.5, 0.25)
      CGAffineTransform.rotation(10).invert.should == CGAffineTransform.rotation(-10)
      CGAffineTransform.translation(2, 4).invert.should == CGAffineTransform.translation(-2, -4)
    end
  end

  describe "#identity?" do
    it "returns true for the identity transform" do
      CGAffineTransform.identity.should.be.identity
    end

    it "returns false for other transforms" do
      CGAffineTransform.translation(1, 2).should.not.be.identity
    end
  end

  describe "#to_value" do
    it "returns a NSValue containing the transform" do
      t = CGAffineTransform.new 1, 2, 3, 4, 5, 6
      t.to_value.CGAffineTransformValue.should == t
    end
  end

  describe "#to_s" do
    it "returns a NSString encoding" do
      CGAffineTransform.new(1, 2, 3, 4, 5, 6).to_s.
        should == "[1, 2, 3, 4, 5, 6]"
    end
  end

end