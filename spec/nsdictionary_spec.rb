describe NSDictionary do

  describe "#to_point" do
    {"X" => 10, "Y" => 10}.to_point.should == CGPointMake(10, 10)
  end

  describe "#to_size" do
    {"Width" => 10, "Height" => 10}.to_size.should == CGSizeMake(10, 10)
  end

  describe "#to_rect" do
    {"X" => 1, "Y" => 2, "Width" => 3, "Height" => 4}.to_rect.should == CGRectMake(1, 2, 3, 4)
  end

end