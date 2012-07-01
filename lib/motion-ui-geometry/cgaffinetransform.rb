class CGAffineTransform

  def initialize(a, b, c, d, tx, ty)
    CGAffineTransformMake(a, b, c, d, tx, ty)
  end


  def self.identity
    CGAffineTransformIdentity
  end

  def self.rotation(angle_in_rad)
    CGAffineTransformMakeRotation(angle_in_rad)
  end

  def self.scale(sx, sy = nil)
    CGAffineTransformMakeScale(sx, sy || sx)
  end

  def self.translation(tx, ty)
    CGAffineTransformMakeTranslation(tx, ty)
  end

  def self.skew(sx, sy)
    CGAffineTransformMake 1.0, sy, sx, 1.0, 0.0, 0.0
  end


  def translate(tx, ty)
    CGAffineTransformTranslate(self, tx, ty)
  end

  def scale(sx, sy = nil)
    CGAffineTransformScale(self, sx, sy || sx)
  end

  def rotate(angle_in_rad)
    CGAffineTransformRotate(self, angle_in_rad)
  end

  def skew(sx, sy)
    self * self.class.skew(sx, sy)
  end


  def invert
    CGAffineTransformInvert self
  end
  alias :inverse :invert

  def concat(other)
    CGAffineTransformConcat self, other
  end

  def apply_on(other)
    other.concat self
  end


  def ==(other)
    other.is_a?(CGAffineTransform) && CGAffineTransformEqualToTransform(self, other)
  end

  def =~(other)
    unless other.is_a? CGAffineTransform
      raise TypeError, "Right operand for =~ must be a CGAffineTransform (got #{other})."
    end

    a =~ other.a &&
      b =~ other.b &&
      c =~ other.c &&
      d =~ other.d &&
      tx =~ other.tx &&
      ty =~ other.ty
  end


  def +(other)
    case other
    when CGSize
      translate other.width, other.height
    when CGPoint
      translate other.x, other.y
    else
      raise TypeError, "Right operand for + and - must be "\
        "CGSize or CGPoint (got #{other.class})."
    end
  end

  def -(other)
    self + (-other)
  end

  def -@
    invert
  end

  def *(other)
    case other
    when Float, Fixnum
      scale other, other
    when CGAffineTransform
      concat other
    else
      raise TypeError, "Right operand for * must be Fixnum, "\
        "Float or CGAffineTransform (got #{other.class})."
    end
  end

  def /(other)
    case other
    when Float, Fixnum
      scale 1.0/other, 1.0/other
    when CGAffineTransform
      concat other.inverse
    else
      raise TypeError, "Right operand for / must be Fixnum, "\
        "Float or CGAffineTransform (got #{other.class})."
    end
  end


  def det
    a * d - b * c
  end


  def identity?
    CGAffineTransformIsIdentity self
  end


  def to_value
    NSValue.valueWithCGAffineTransform self
  end

  def to_s
    NSStringFromCGAffineTransform self
  end

end