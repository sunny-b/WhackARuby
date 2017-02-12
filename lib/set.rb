
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
