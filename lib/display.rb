# Module that contains all display methods
module Displayable
  GAME_TIME = 45
  SCREEN_HEIGHT = 600
  SCREEN_WIDTH = 800
  MILLISECONDS = 1000
  SCORE_INCREMENT = 5

  private

  def display_tokens
    @gems.each { |rock| rock.draw }
    @hammer.draw(mouse_x - 30, mouse_y - 30, 1)
  end

  def display_header
    @font.draw(@score.to_s, 700, 50, 2)
    @font.draw(@time.to_s, 100, 50, 2)
    @font_smaller.draw("Don't Hit the Emeralds!", 326, 20, 2)
  end

  def display_game_over
    @gems.each { |rock| rock.reveal }
    @font.draw('GAME OVER', 300, 300, 2)
    @font.draw('Press the Space Bar to Play Again', 175, 350, 3)
  end

  def display_color
    color = determine_color(@ruby, @emerald)
    draw_quad(0, 0, color,
              SCREEN_WIDTH, 0, color,
              SCREEN_WIDTH, SCREEN_HEIGHT, color,
              0, SCREEN_HEIGHT, color)
  end
end
