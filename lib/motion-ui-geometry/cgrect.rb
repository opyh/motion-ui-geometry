class CGRect

  def initialize(origin = nil, size = nil)
    if origin.nil? || size.nil?
      raise ArgumentError, "Can't initialize CGRect without given origin and size."
    end

    unless origin.is_a?(CGPoint)
      raise TypeError, "origin must be given as CGPoint."
    end

    unless size.is_a?(CGSize)
      raise TypeError, "size must be given as CGSize."
    end

    self.origin = origin
    self.size = size

    self
  end


  def ==(other)
    other.is_a?(CGRect) &&
      origin.x == other.origin.x &&
      origin.y == other.origin.y &&
      size.width == other.size.width &&
      size.height == other.size.height
  end

  def roughly_equal?(other, epsilon = Float::EPSILON)
    unless other.is_a? CGRect
      raise TypeError, "Right operand for =~ must be a CGRect (got #{other})."
    end

    origin.x.roughly_equal?(other.origin.x, epsilon) &&
      origin.y.roughly_equal?(other.origin.y, epsilon) &&
      size.width.roughly_equal?(other.size.width, epsilon) &&
      size.height.roughly_equal?(other.size.height, epsilon)
  end

  def =~(other)
    roughly_equal?(other)
  end


  def +(other)
    case other
    when CGPoint
      CGRect.new origin + other, size
    when CGSize
      CGRect.new origin, size + other
    else
      raise TypeError, "Right operand for + and - must be a "\
        "CGPoint or a CGRect (got #{other.class})."
    end
  end

  def -(other)
    self + (-other)
  end

  def -@
    CGRectMake -origin.x, -origin.y, -size.width, -size.height
  end

  def *(other)
    case other
    when Fixnum, Float
      CGRectMake origin.x   * other, origin.y    * other,
                 size.width * other, size.height * other
    when CGSize
      CGRectMake origin.x   * other.width, origin.y    * other.height,
                 size.width * other.width, size.height * other.height
    when CGPoint
      CGRectMake origin.x   * other.x, origin.y    * other.y,
                 size.width * other.x, size.height * other.y
    when CGAffineTransform
      CGRectApplyAffineTransform self, other
    else
      raise TypeError, "Right operand for * must be Fixnum, "\
        "Float, Array, CGPoint, CGSize or CGAffineTransform "\
        "(got #{other.class})."
    end
  end

  def /(other)
    case other
    when Float
      CGRectMake origin.x   / other, origin.y    / other,
                 size.width / other, size.height / other
    when CGSize
      CGRectMake origin.x   / other.width, origin.y    / other.height,
                 size.width / other.width, size.height / other.height
    when CGPoint
      CGRectMake origin.x   / other.x, origin.y    / other.y,
                 size.width / other.x, size.height / other.y
    when CGAffineTransform
      CGRectApplyAffineTransform self, other.inverse
    else
      raise TypeError, "Right operand for / must be Float, "\
        "CGPoint, CGSize or CGAffineTransform (got #{other.class})."
    end

  end

  def &(other)
    intersection(other)
  end

  def |(other)
    union(other)
  end


  def round
    CGRect.new origin.round, size.round
  end

  def floor
    CGRect.new origin.floor, size.floor
  end



  def inset(dx, dy)
    CGRectInset self, dx, dy
  end

  def outset(dx, dy)
    inset -dx, -dy
  end

  def union(rect)
    unless rect.is_a? CGRect
      raise TypeError, "Parameter must be a CGRect, got #{rect}."
    end

    CGRectUnion self, rect
  end
  alias :unionize  :union

  def intersection(rect)
    unless rect.is_a? CGRect
      raise TypeError, "Parameter must be a CGRect, got #{rect}."
    end

    CGRectIntersection self, rect
  end
  alias :intersect :intersection

  def division(amount, edge = :left)
    unless amount.is_a?(Float) || amount.is_a?(Fixnum)
      raise ArgumentError, "amount must be given as Float or Fixnum, got #{amount}."
    end

    unless [:left, :right, :top, :bottom].include? edge
      raise ArgumentError, "edge must be :left, :right, :top, or :bottom (got #{edge})."
    end

    slice = Pointer.new(CGRect.type)
    remainder = Pointer.new(CGRect.type)

    edge = case edge
    when :left   then CGRectMinXEdge
    when :right  then CGRectMaxXEdge
    when :top    then CGRectMinYEdge
    when :bottom then CGRectMaxYEdge
    end

    CGRectDivide self, slice, remainder, amount, edge

    [slice[0], remainder[0]]
  end
  alias :divide :division

  def intersect?(other)
    unless other.is_a? CGRect
      raise TypeError, "Parameter must be a CGRect, got #{other}."
    end

    CGRectIntersectsRect self, other
  end

  def contain?(point_or_rect)
    case point_or_rect
    when CGPoint then CGRectContainsPoint self, point_or_rect
    when CGRect then CGRectContainsRect self, point_or_rect
    else raise TypeError, "Parameter must be a CGPoint or CGRect, got #{point_or_rect}."
    end
  end

  def empty?
    CGRectIsEmpty self
  end

  def null?
    CGRectIsNull self
  end

  # TODO: Does not work with CGRectInfinite, but should do so.
  # def infinite?
  #   CGRectIsInfinite self
  # end


  def apply(transform)
    CGRectApplyAffineTransform(self, transform)
  end


  def center
    origin + size * 0.5
  end

  def top_left
    origin
  end

  def bottom_left
    CGPointMake(origin.x, origin.y + size.height)
  end

  def bottom_right
    origin + size
  end

  def top_right
    CGPointMake(origin.x + size.width, origin.y)
  end


  def to_dictionary
    CGRectCreateDictionaryRepresentation self
  end

  def to_value
    NSValue.valueWithCGRect self
  end

  def to_s
    NSStringFromCGRect self
  end


end
