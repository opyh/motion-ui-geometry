# motion-ui-geometry

Write Cocoa Touch UIs like a boss™! A gem
designed for [RubyMotion](http://rubymotion.com) for iOS.

##

## Usage

### OOP-Style Access to Geometry Functions

Carefully adapted to match Ruby's style while keeping method names
obvious for people with CoreGraphics knowledge.

Some examples:

#### `Float`

```ruby
my_float.clamp(min, max)
my_float.to_radians
my_float.to_degrees
```

#### `CGPoint`

```ruby
integer_point = point.round
integer_point = point.floor
point.distance_to other_point
point.clamp_to_rect boundary_rect # returns the nearest point inside given rect
point.to_size
```

#### `CGSize`

```ruby
integer_size = size.round
integer_size = size.floor
size.to_point
```

#### `CGRect`

```ruby
rect = CGRect.from_origin(origin, size)

rect.empty?
rect.intersect?(other_rect)
rect.contain?(other_rect)
rect.null?

rect.inset(5, 5)
rect.union(other_rect)
rect.intersection(other_rect)
[right_division, left_division] = rect.divide(0.2, :right)

rect.top_left, rect.bottom_left, rect.bottom_right, rect.top_right
center_point = rect.center
```

#### `CGAffineTransform`

```ruby
identity_transform = CGAffineTransform.identity

CGAffineTransform.rotation(angle)
CGAffineTransform.scale(sx, sy)
CGAffineTransform.translation(tx, ty)
CGAffineTransform.skew(sx, sy)

my_transform.rotate(angle)
my_transform.scale(sx, sy)
my_transform.translate(tx, ty)
my_transform.skew(sx, sy)

transformed_transform = my_transform.concat other_transform
transformed_transform = other_transform.apply_on my_transform
determinant = transform.det

transform.identity?

inverse = some_transform.invert
some_transform * inverse == CGAffineTransform.identity
```

#### Obtaining `NSValue`s

Handy for use with CoreAnimation.

Just call `#to_value` on your geometry:

```ruby
float_value = some_float.to_value
point_value = some_point.to_value
size_value = some_size.to_value
rect_value = some_rect.to_value
transform_value = some_transform.to_value
```

#### Conversion from/to `NSString` and `NSDictionary`

Handy for serialization:

```ruby
point.to_s
size.to_s
rect.to_s
transform.to_s

string.to_point
string.to_size
string.to_rect
string.to_transform
```

### Approximate Comparison of Geometry via `=~`

```ruby
some_float =~ 1.5                      # => true if float is ~1.5
some_float.roughly_equal?(1.5, 0.001)  # => true if float is ~1.5 within 0.001 error margin

rect == other_rect            # => true if coordinates are exactly equal

size =~ other_size            # => true if coordinates are roughly equal
point =~ other_point          # => true if coordinates are roughly equal
transform =~ other_transform  # => true if coordinates are roughly equal
```

### Transforming Geometry Using Operators

I have tried to keep operator behavior obvious.

#### `+ - * /` + Operand Type Mixing

```ruby
offset_point   = point + other_point
offset_point   = point - offset_size
negative_point = -point

offset_size    = size + offset_point
offset_size    = size - offset_size
negative_size  = -size

offset_rect    = rect + point
offset_rect    = rect + size
negative_rect  = -rect

scaled_point   = point * 3.0
scaled_size    = size * 2.0
scaled_rect    = rect * 4.0
scaled_rect    = rect * CGSizeMake(1, 2)

scaled_point   = point / 3.0
scaled_size    = size / 2.0
scaled_rect    = rect / 4.0

offset_rect    = rect + point
resized_rect   = rect + size
```

#### Scale, Rotate, Transform and Skew `UIView`s and Geometry

Just create a `CGAffineTransform` and multiply with it to transform:

```ruby
double_size = CGAffineTransform.scale(2.0, 2.0)
rotation = CGAffineTransform.rotation(30.0.to_rad)

my_image_view.transform = rotation

rotated_point = point * rotation
rotated_size = size * rotation
rotated_rect = rect * rotation

scaled_rotation = rotation * double_size
scaled_transform = some_transform * 2.0 # scales x and y

scaled_rotated_rect = rect * scaled_rotation
scaled_rotated_point = point * scaled_rotation

translated_transform       = transform + offset_point
other_translated_transform = transform + offset_size
```

#### Unionize and Intersect `CGRect`s

```ruby
union          = rect1 | rect2
intersection   = rect1 & rect2
```

## Installation

1. If not done yet, add `bundler` gem management to your RubyMotion app.
   See <http://thunderboltlabs.com/posts/using-bundler-with-rubymotion> for
   an explanation how.

2. Add this line to your application's Gemfile:

   ```ruby
   gem 'motion-ui-geometry'
   ```

3. Execute:

   ```bash
   $ bundle
   ```

## Contributing

Feel free to fork the project and send me a pull request if you would
like me to integrate your bugfix, enhancement, or feature. I'm also open for suggestions regarding new features and the interface design.

To contribute,

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

If the feature has specs, I will probably merge it :)
