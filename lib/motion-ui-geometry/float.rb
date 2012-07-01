class Float

  EPSILON = 0.00001

  def clamp(min, max)
    max = 0 + max
    min = 0 + min

    min, max = max, min if min > max

    if self > max
      max
    elsif self < min
      min
    else
      self
    end
  end

  def to_radians
    self * Math::PI / 180.0
  end
  alias :to_rad :to_radians

  def to_degrees
    self * 180.0 / Math::PI
  end
  alias :to_deg :to_degrees

  def roughly_equal?(other, epsilon = EPSILON)
    (self - other).abs <= epsilon
  end

  def =~(other)
    roughly_equal?(other)
  end

  def to_value
    NSNumber.numberWithFloat self
  end

end
