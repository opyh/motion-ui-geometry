class CGSize

  def ==(other)
    other.is_a?(CGSize) && width == other.width && height == other.height
  end

  def =~(other)
    case other
    when CGPoint
      width =~ other.x && height =~ other.y
    when CGSize
      width =~ other.width && height =~ other.height
    else
      raise TypeError, "Right operand for =~ must be CGPoint or CGSize. (got #{other.class})"
    end
  end

  def +(other)
    case other
    when CGSize
      CGSizeMake width + other.width, height + other.height
    when CGPoint
      CGSizeMake width + other.x, height + other.y
    else
      raise TypeError, "Right operand for + must be CGSize or CGPoint (got #{other.class})"
    end
  end

  def -(other)
    case other
    when CGSize
      CGSizeMake width - other.width, height - other.height
    when CGPoint
      CGSizeMake width - other.x, height - other.y
    else
      raise TypeError, "Right operand for - must be CGSize or CGPoint (got #{other.class})"
    end
  end

  def -@
    CGSizeMake -width, -height
  end

  def *(other)
    case other
    when Fixnum, Float
      CGSizeMake other * width, other * height
    when CGSize
      CGSizeMake width * other.width, height * other.height
    when CGPoint
      CGSizeMake width * other.x, height * other.y
    when CGAffineTransform
      CGSizeApplyAffineTransform self, other
    else
      raise TypeError, "Right operand for * must be a Fixnum, Float, "\
        "CGSize, CGPoint, or CGAffineTransform (got #{other.class})"
    end
  end

  def /(other)
    case other
    when Float
      CGSizeMake other / width, other / height
    when CGSize
      CGSizeMake width / other.width, height / other.height
    when CGPoint
      CGSizeMake width / other.x, height / other.y
    when CGAffineTransform
      CGSizeApplyAffineTransform self, other.inverse
    else
      raise TypeError, "Right operand for / must be a Float, "\
        "CGSize, CGPoint, or CGAffineTransform (got #{other.class})"
    end
  end


  def round
    CGSizeMake width.round, height.round
  end

  def floor
    CGSizeMake width.floor, height.floor
  end


  def apply(transform)
    CGSizeApplyAffineTransform(self, transform)
  end


  def to_point
    CGPointMake width, height
  end

  def to_rect
    CGRect.new CGPointZero, self
  end

  def to_dictionary
    CGSizeCreateDictionaryRepresentation self
  end

  def to_value
    NSValue.valueWithCGSize self
  end

  def to_s
    NSStringFromCGSize self
  end

end
