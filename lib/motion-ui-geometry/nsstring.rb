class NSString
  def to_point
    CGPointFromString(self)
  end

  def to_size
    CGSizeFromString(self)
  end

  def to_rect
    CGRectFromString(self)
  end

  def to_transform
    CGAffineTransformFromString(self)
  end
end