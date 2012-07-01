class CGPoint

  def ==(other)
    other.is_a?(CGPoint) && x == other.x && y == other.y
  end

  def =~(other)
    case other
    when CGPoint
      x =~ other.x && y =~ other.y
    when CGSize
      x =~ other.width && y =~ other.height
    else
      raise TypeError, "Right operand for =~ must be "\
        "CGPoint or CGSize (got #{other})."
    end
  end


  def +(other)
    case other
    when CGPoint
      CGPointMake x + other.x, y + other.y
    when CGSize
      CGPointMake x + other.width, y + other.height
    else
      raise TypeError, "Right operand for + must be "\
        "CGPoint or CGSize (got #{other})."
    end
  end

  def -(other)
    case other
    when CGPoint
      CGPointMake x - other.x, y - other.y
    when CGSize
      CGPointMake x - other.width, y - other.height
    else
      raise TypeError, "Right operand for - must be "\
        "CGPoint or CGSize (got #{other})."
    end
  end

  def -@
    CGPointMake -x, -y
  end

  def apply(transform)
    unless transform.is_a? CGAffineTransform
      raise TypeError, "Parameter must be a CGAffineTransform, got #{transform}."
    end

    CGPointApplyAffineTransform(self, transform)
  end

  def *(other)
    case other
    when Fixnum, Float
      CGPointMake(x * other, y * other)
    when CGPoint
      CGPointMake(x * other.x, y * other.y)
    when CGSize
      CGPointMake(x * other.width, y * other.height)
    when CGAffineTransform
      apply other
    else
      raise TypeError, "Right operand for * must be "\
        "Fixnum, Float, CGPoint, CGSize or CGAffineTransform "\
        "(got #{other})."
    end
  end

  def /(other)
    case other
    when Fixnum, Float
      CGPointMake(x / other, y / other)
    when CGPoint
      CGPointMake(x / other.x, y / other.y)
    when CGSize
      CGPointMake(x / other.width, y / other.height)
    when CGAffineTransform
      apply self.invert
    else
      raise TypeError, "Right operand for / must be "\
        "Fixnum, Float, CGPoint, CGSize or CGAffineTransform "\
        "(got #{other})"
    end
  end


  def round
    CGPointMake x.round, y.round
  end

  def floor
    CGPointMake x.floor, y.floor
  end

  def distance_to(other)
    unless other.is_a? CGPoint
      raise TypeError, "Parameter must be a CGPoint, got #{other}."
    end

    dist_x = x - other.x
    dist_y = y - other.y

    Math.sqrt(dist_x ** 2 + dist_y ** 2).abs
  end

  def clamp_to_rect(rect)
    unless rect.is_a? CGRect
      raise TypeError, "Parameter must be a CGRect, got #{rect}."
    end

    p = CGPoint.new
    p.x = x.clamp(rect.origin.x, rect.origin.x + rect.size.width)
    p.y = y.clamp(rect.origin.y, rect.origin.y + rect.size.height)
    p
  end

  def angle
    Math.atan2 y, x
  end

  def to_size
    CGSizeMake x, y
  end

  def to_dictionary
    CGPointCreateDictionaryRepresentation self
  end

  def to_value
    NSValue.valueWithCGPoint self
  end

  def to_s
    NSStringFromCGPoint self
  end


end
