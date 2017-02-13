
module Setable
  private

  def set_hit_count
    @ruby.reset_hit_score
    @emerald.reset_hit_score
  end

  def new_game_reset
    set_starting_values
    set_tokens
    @start_time = Gosu.milliseconds
  end

  def set_fonts
    @font = Gosu::Font.new(30)
    @font_smaller = Gosu::Font.new(15)
  end

  def set_starting_values
    @score = 0
    @playing = true
  end

  def set_tokens
    @ruby = Ruby.new(200, 200)
    @emerald = Emerald.new(600, 400)
    @hammer = Gosu::Image.new('images/hammer.png')
  end

  def set_initial_values
    set_tokens
    set_hit_count
    set_fonts
    set_starting_values
    @start_time = 0
  end
end
