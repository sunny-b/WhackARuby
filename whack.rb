Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }
require 'gosu'

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
