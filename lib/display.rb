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
