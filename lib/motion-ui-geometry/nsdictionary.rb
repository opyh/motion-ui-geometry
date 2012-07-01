class NSDictionary

  def to_point
    point = Pointer.new CGPoint.type
    CGPointMakeWithDictionaryRepresentation self, point
    point[0]
  end

  def to_size
    size = Pointer.new CGSize.type
    CGSizeMakeWithDictionaryRepresentation self, size
    size[0]
  end

  def to_rect
    rect = Pointer.new CGRect.type
    CGRectMakeWithDictionaryRepresentation self, rect
    rect[0]
  end

end