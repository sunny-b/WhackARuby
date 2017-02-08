require 'gosu'

module Displayable
  def display_tokens
    display_ruby
    display_emerald
    display_hammer
  end

  def display_ruby
    if @visible_rb > 0
      @ruby.draw(@x_rb - @width_rb / 2, @y_rb - @height_rb / 2, 1)
    end
  end

  def display_emerald
    if @visible_em > 0
      @emerald.draw(@x_em - @width_em / 2, @y_em - @height_em / 2, 1)
    end
  end

  def display_hammer
    @hammer.draw(mouse_x - 30, mouse_y - 30, 1)
  end

  def display_header
    @font.draw(@score.to_s, 700, 50, 2)
    @font.draw(@time.to_s, 100, 50, 2)
    @font_smaller.draw("Don't Hit the Emerald!", 326, 20, 2)
  end

  def display_game_over
    @visible_rb = 20
    @font.draw("GAME OVER", 300, 300, 2)
    @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
  end

  def display_color
    color = determine_color(@hit_rb, @hit_em)
    draw_quad(0, 0, color, 800, 0, color, 800, 600, color, 0, 600, color)
  end

end

# WhackARuby class is subclass of the Gosu::Window class
# This will allow to use methods to create a game window.
class WhackARuby < Gosu::Window
  include Displayable

  def initialize
    # Telling Gosu::Window to make a window 800px by 600px;
    super(800, 600)
    self.caption = 'Whack the Ruby!'
    set_initial_values
  end

  def draw
    # invoking the draw instance method of the Gosu::Image class.
    # Telling Gosu::Image to draw the image from its center point
    # and not from the top left corner
    display_tokens
    display_color
    reset_hit_count
    display_header

    unless @playing
      display_game_over
    end
  end

  # the Gosu::Window update method is essentially another word for "animate"
  # It updates the frame and the positions of the objects so they appear to move
  def update
    if @playing
      # Move the position of ruby and emerald and make them blink
      move_ruby_and_emerald
      decrement_visibility

      # Reverse velocity when ruby gets to edge of window
      bounce_off_edge_of_screen

      # Make ruby and emerald blink
      reveal_ruby_and_emerald

      @time = 60 - ((Gosu.milliseconds - @start_time) / 1000)
      @playing = false unless @time > 0
    end
  end

  # Creating mouse click event
  def button_down(id)
    if @playing
      if (id == Gosu::MsLeft)
        update_score
      end
    else
      if (id == Gosu::KbSpace)
        new_game_reset
      end
    end
  end

  private

  def reset_hit_count
    @hit_rb = 0
    @hit_em = 0
  end

  def determine_color(ruby, emerald)
    if ruby == 0 && emerald == 0
      Gosu::Color::NONE
    elsif ruby == 1
      Gosu::Color::GREEN
    elsif emerald == 1
      Gosu::Color.argb(0xff_ad42f4)
    elsif ruby == -1
      Gosu::Color::RED
    end
  end

  def update_score
    if hit_ruby?(@x_rb, @y_rb, @visible_rb)
      @hit_rb = 1
      @score += 5
    elsif hit_emerald?(@x_em, @y_em, @visible_em)
      @hit_em = 1
      @score -= 5
    else
      @hit_rb = -1
      @score -= 1
    end
  end

  def hit_ruby?(x_pos, y_pos, visibility)
    Gosu.distance(mouse_x, mouse_y, x_pos, y_pos) < 75 && visibility > 0
  end

  def hit_emerald?(x_pos, y_pos, visibility)
    Gosu.distance(mouse_x, mouse_y, x_pos, y_pos) < 100 && visibility > 0
  end

  def edge_of_screen_width?(position, width)
    position + width / 2 > 800  || position - width / 2 < 0
  end

  def edge_of_screen_height?(position, height)
    position + height / 2 > 600 || position - height / 2 < 0
  end

  def reveal_ruby_and_emerald
    @visible_rb = 75 if @visible_rb < -10 and rand < 0.01
    @visible_em = 100 if @visible_em < -10 and rand < 0.02
  end

  def bounce_off_edge_of_screen
    @velocity_x_rb *= -1 if edge_of_screen_width?(@x_rb, @width_rb)
    @velocity_y_rb *= -1 if edge_of_screen_height?(@y_rb, @height_rb)
    @velocity_x_em *= -1 if edge_of_screen_width?(@x_em, @width_em)
    @velocity_y_em *= -1 if edge_of_screen_height?(@y_em, @height_em)
  end

  def move_ruby_and_emerald
    @x_rb += @velocity_x_rb
    @y_rb += @velocity_y_rb
    @x_em += @velocity_x_em
    @y_em += @velocity_y_em
  end

  def decrement_visibility
    @visible_em -= 1
    @visible_rb -= 1
  end

  def new_game_reset
    @playing = true
    @visible_rb = -10
    @start_time = Gosu.milliseconds
    @score = 0
  end

  def set_initial_values
    # Creating an instance of class Gosu::Image so that I can draw a picture.
    @ruby = Gosu::Image.new('images/ruby.png')
    @emerald = Gosu::Image.new('images/emerald.png')
    @hammer = Gosu::Image.new('images/hammer.png')

    # Tellling Gosu::Window to initialize the ruby image at
    # 200px from the top and left
    @x_rb = 200
    @y_rb = 200

    @x_em = 600
    @y_em = 400

    @width_rb = 50
    @height_rb = 42

    @width_em = 50
    @height_em = 30

    # Setting the velocity of x and y so the image will move
    @velocity_x_rb = 5
    @velocity_y_rb = 5

    @velocity_x_em = 3
    @velocity_y_em = 3

    @visible_rb = 10
    @visible_em = 10

    reset_hit_count

    @font = Gosu::Font.new(30)
    @font_smaller = Gosu::Font.new(15)
    @score = 0
    @playing = true
    @start_time = 0
  end
end

window = WhackARuby.new
window.show
