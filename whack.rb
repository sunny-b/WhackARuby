Dir[File.dirname(__FILE__) + '/lib/*.rb'].each {|file| require file }

class WhackARuby < Gosu::Window
  include Displayable
  include Setable

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT)
    self.caption = 'Whack the Ruby!'
    set_initial_values
  end

  def draw
    display_tokens
    display_color
    set_hit_count
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
    id == Gosu::KbSpace
  end

  def left_mouse_button?(id)
    id == Gosu::MsLeft
  end

  def determine_color(ruby, emerald)
    if ruby.hit_score.zero? && emerald.hit_score.zero?
      Gosu::Color::NONE
    elsif ruby.hit_score == 1
      Gosu::Color::GREEN
    elsif emerald.hit_score == 1
      Gosu::Color.argb(0xff_ad42f4)
    elsif ruby.hit_score == -1
      Gosu::Color::RED
    end
  end

  def update_score
    if hit?(@ruby)
      @ruby.was_hit
      @score += SCORE_INCREMENT
    elsif hit?(@emerald)
      @emerald.was_hit
      @score -= SCORE_INCREMENT
    else
      @ruby.was_missed
      @score -= 1
    end
  end

  def hit?(gems)
    Gosu.distance(mouse_x,
                  mouse_y,
                  gems.x,
                  gems.y) < gems.hit_radius && gems.visible?
  end

  def edge_of_screen_width?(gems)
    gems.x + gems.width / 2 > SCREEN_WIDTH || gems.x - gems.width / 2 < 0
  end

  def edge_of_screen_height?(gems)
    gems.y + gems.height / 2 > SCREEN_HEIGHT || gems.y - gems.height / 2 < 0
  end

  def reveal_ruby_and_emerald
    @ruby.reveal if @ruby.invisible? && rand < 0.01
    @emerald.reveal if @emerald.invisible? && rand < 0.02
  end

  def bounce_off_edge_of_screen
    @ruby.reverse_x if edge_of_screen_width?(@ruby)
    @ruby.reverse_y if edge_of_screen_height?(@ruby)
    @emerald.reverse_x if edge_of_screen_width?(@emerald)
    @emerald.reverse_y if edge_of_screen_height?(@emerald)
  end

  def move_ruby_and_emerald
    @ruby.move
    @emerald.move
  end

  def decrement_visibility
    @ruby.decrement_visibility
    @emerald.decrement_visibility
  end
end

window = WhackARuby.new
window.show
