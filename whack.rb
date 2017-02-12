require 'gosu'
require 'pry'

# Module that contains all display methods
module Displayable
  GAME_TIME = 60
  SCREEN_HEIGHT = 600
  SCREEN_WIDTH = 800
  MILLISECONDS = 1000
  SCORE_INCREMENT = 5

  private

  def display_tokens
    display_ruby
    display_emerald
    display_hammer
  end

  def display_ruby
    center_width = @x_rb - @width_rb / 2
    center_height = @y_rb - @height_rb / 2
    @ruby.draw(center_width, center_height, 1) if @visible_rb > 0
  end

  def display_emerald
    center_width = @x_em - @width_em / 2
    center_height = @y_em - @height_em / 2
    @emerald.draw(center_width, center_height, 1) if @visible_em > 0
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
    @font.draw('GAME OVER', 300, 300, 2)
    @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
  end

  def display_color
    color = determine_color(@hit_rb, @hit_em)
    draw_quad(0, 0, color,
              SCREEN_WIDTH, 0, color,
              SCREEN_WIDTH, SCREEN_HEIGHT, color,
              0, SCREEN_HEIGHT, color)
  end
end

module Setable
  START_POSITION_RB = 200
  START_POSITION_X_EM = 600
  START_POSITION_Y_EM = 400
  VISIBILITY_MIN = -10
  GEM_WIDTH = 50
  RB_HEIGHT = 42
  EM_HEIGHT = 30

  private

  def reset_hit_count
    @hit_rb = 0
    @hit_em = 0
  end

  def new_game_reset
    set_starting_values
    set_visibility
    @start_time = Gosu.milliseconds
  end

  def show_images
    @ruby = Gosu::Image.new('images/ruby.png')
    @emerald = Gosu::Image.new('images/emerald.png')
    @hammer = Gosu::Image.new('images/hammer.png')
  end

  def set_position_width_height
    @x_rb = START_POSITION_RB
    @y_rb = START_POSITION_RB

    @x_em = START_POSITION_X_EM
    @y_em = START_POSITION_Y_EM

    @width_rb = GEM_WIDTH
    @height_rb = RB_HEIGHT

    @width_em = GEM_WIDTH
    @height_em = EM_HEIGHT
  end

  def set_velocity
    @velocity_x_rb = 5
    @velocity_y_rb = 5

    @velocity_x_em = 3
    @velocity_y_em = 3
  end

  def set_visibility
    @visible_rb = VISIBILITY_MIN
    @visible_em = VISIBILITY_MIN
  end

  def set_fonts
    @font = Gosu::Font.new(30)
    @font_smaller = Gosu::Font.new(15)
  end

  def set_starting_values
    @score = 0
    @playing = true
  end

  def set_initial_values
    show_images
    set_position_width_height
    set_velocity
    set_visibility
    reset_hit_count
    set_fonts
    set_starting_values
    @start_time = 0
  end
end

class WhackARuby < Gosu::Window
  include Displayable
  include Setable

  RUBY_HIT_RADIUS = 75
  RUBY_VISIBILITY = 75
  EMERALD_HIT_RADIUS = 100
  EMERALD_VISIBILITY = 100

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Whack the Ruby!'
    set_initial_values
  end

  def draw
    display_tokens
    display_color
    reset_hit_count
    display_header
    display_game_over unless @playing
  end

  def update
    game_loop if @playing
  end

  def button_down(id)
    if @playing
      update_score if left_mouse_button?(id)
    elsif space_bar?(id)
      new_game_reset
    end
  end

  private

  def game_loop
    move_ruby_and_emerald
    decrement_visibility
    bounce_off_edge_of_screen
    reveal_ruby_and_emerald

    @time = GAME_TIME - ((Gosu.milliseconds - @start_time) / MILLISECONDS)
    @playing = false unless @time > 0
  end

  def space_bar?(id)
    id == Gosu::MsLeft
  end

  def left_mouse_button?(id)
    id == Gosu::MsLeft
  end

  def determine_color(ruby_hit_score, emerald_hit_score)
    if ruby_hit_score.zero? && emerald_hit_score.zero?
      Gosu::Color::NONE
    elsif ruby_hit_score == 1
      Gosu::Color::GREEN
    elsif emerald_hit_score == 1
      Gosu::Color.argb(0xff_ad42f4)
    elsif ruby_hit_score == -1
      Gosu::Color::RED
    end
  end

  def update_score
    if hit_ruby?(@x_rb, @y_rb, @visible_rb)
      @hit_rb = 1
      @score += SCORE_INCREMENT
    elsif hit_emerald?(@x_em, @y_em, @visible_em)
      @hit_em = 1
      @score -= SCORE_INCREMENT
    else
      @hit_rb = -1
      @score -= 1
    end
  end

  def hit_ruby?(x_pos, y_pos, visibility)
    Gosu.distance(mouse_x, mouse_y, x_pos, y_pos) < RUBY_HIT_RADIUS &&
    visibility > 0
  end

  def hit_emerald?(x_pos, y_pos, visibility)
    Gosu.distance(mouse_x, mouse_y, x_pos, y_pos) < EMERALD_HIT_RADIUS &&
    visibility > 0
  end

  def edge_of_screen_width?(position, width)
    position + width / 2 > SCREEN_WIDTH || position - width / 2 < 0
  end

  def edge_of_screen_height?(position, height)
    position + height / 2 > SCREEN_HEIGHT || position - height / 2 < 0
  end

  def reveal_ruby_and_emerald
    @visible_rb = RUBY_VISIBILITY if invisible?(@visible_rb) && rand < 0.01
    @visible_em = EMERALD_VISIBILITY if invisible?(@visible_em) && rand < 0.02
  end

  def invisible?(gem_visibility)
    gem_visibility < Setable::VISIBILITY_MIN
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
end

window = WhackARuby.new
window.show
