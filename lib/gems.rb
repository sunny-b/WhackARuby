require 'gosu'

class Gems
  VISIBILITY_MIN = -10

  attr_reader :width, :height, :hit_radius, :x, :y, :hit_score

  def initialize(x, y, width, height, velocity, image_url, hit_radius)
    @x = x
    @y = y
    @width = width
    @height = height
    @velocity_x = velocity
    @velocity_y = velocity
    @visibility = VISIBILITY_MIN
    @hit_score = 0
    @image = Gosu::Image.new(image_url)
    @hit_radius = hit_radius
  end

  def draw
    center_width = x - width / 2
    center_height = y - height / 2
    image.draw(center_width, center_height, 1) if visibility > 0
  end

  def invisible?
    visibility < VISIBILITY_MIN
  end

  def visible?
    visibility > 0
  end

  def move
    @x += velocity_x
    @y += velocity_y
  end

  def reverse_x
    @velocity_x *= -1
  end

  def reverse_y
    @velocity_y *= -1
  end

  def was_hit
    @hit_score += 1
  end

  def was_missed
    @hit_score -= 1
  end

  def reset_hit_score
    @hit_score = 0
  end

  def decrement_visibility
    @visibility -= 1
  end

  private

  attr_reader :image, :velocity_x, :velocity_y, :visibility
end

class Ruby < Gems
  HIT_RADIUS = 75
  VISIBILITY = 75

  def initialize(x, y)
    random_velocity = rand(5) + 4
    super(x, y, 50, 42, random_velocity, 'images/ruby.png', HIT_RADIUS)
  end

  def reveal
    @visibility = VISIBILITY
  end
end

class Emerald < Gems
  HIT_RADIUS = 100
  VISIBILITY = 100

  def initialize(x, y)
    random_velocity = rand(5) + 4
    super(x, y, 50, 30, random_velocity, 'images/emerald.png', HIT_RADIUS)
  end

  def reveal
    @visibility = VISIBILITY
  end
end
