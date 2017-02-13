
module Setable
  private

  def set_hit_count
    @gems.each { |rock| rock.reset_hit_score }
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

  def set_rubys
    @ruby = Ruby.new(200, 100)
    @ruby2 = Ruby.new(400, 500)
    @ruby3 = Ruby.new(300, 200)

    [@ruby, @ruby2, @ruby3]
  end

  def set_emeralds
    @emerald = Emerald.new(600, 400)
    @emerald2 = Emerald.new(200, 400)
    @emerald3 = Emerald.new(500, 100)

    [@emerald, @emerald2, @emerald3]
  end

  def set_tokens
    @rubys = set_rubys
    @emeralds = set_emeralds

    @gems = [@rubys, @emeralds].flatten
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
