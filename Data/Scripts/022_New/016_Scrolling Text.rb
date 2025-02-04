=begin
class ScrollingTextSprite < Sprite
  def initialize(text, x, y, width, scroll_speed, max_loops = 2, viewport = nil)
    super(viewport)
    @viewport = viewport
    @text = text
    @x = x
    @y = y
    @width = width
    @scroll_speed = scroll_speed
    @max_loops = max_loops
    @loop_count = 0
    @disposed = false
    @bitmap = Bitmap.new(@width, 32)  # Create a new bitmap with the specified width
    self.bitmap = @bitmap
    self.z = 99998
  end

  def dispose
    @bitmap.dispose if @bitmap  # Dispose of the bitmap if it exists
    @disposed = true
  end
  
  def disposed?
    return @disposed
  end

  def update
    return if @disposed || @bitmap.disposed?
    @x = (@x / 2) * 2  # Ensure @x is an even number
    @x -= @scroll_speed
    if @x <= -(@bitmap.width)  # Check if the entire text has moved off the left side
      dispose
      return
    end
    draw_background
    draw_text
  end

  def draw_background
    @bitmap.fill_rect(0, 0, @bitmap.width, @bitmap.height, Color.new(0, 0, 0, 128))  # Fill with black color
  end

  def draw_text
    pbSetSystemFont(@bitmap)
    x_offset = @x
    text_to_draw = @text
    @bitmap.draw_text(x_offset, 6, @width, 20, text_to_draw)
  end
end

# Define the scrolling_text_strings array globally or within a module/class
$scrolling_text_strings = []

# Add a method to add strings to the scrolling_text_strings array
def add_scrolling_text(text)
  $scrolling_text_strings << text
end

$scrolling_text_strings = []
#$last_scrolling_text_time = 0
$scrolling_text_delay = 60*10  # Number of frames to wait before creating another scrolling text

def add_scrolling_text(text)
  $scrolling_text_strings << text
end

# Initialize $last_scrolling_text_time outside the event handler
$last_scrolling_text_time ||= Graphics.frame_count

EventHandlers.add(:on_frame_update, :show_scrolling_text,
  proc { |scene|
    current_time = Graphics.frame_count
    if current_time - $last_scrolling_text_time >= $scrolling_text_delay
      spriteset = $scene.spriteset
      existing_scroll_text = spriteset.usersprites.find { |sprite| sprite.is_a?(ScrollingTextSprite) && !sprite.disposed? }

      # Remove disposed ScrollingTextSprite from usersprites array
      if existing_scroll_text && existing_scroll_text.disposed?
        #puts "there"
        spriteset.usersprites.delete(existing_scroll_text)
        existing_scroll_text = nil
      end

      unless existing_scroll_text
        unless $scrolling_text_strings.empty?
          #puts "here"
          text = $scrolling_text_strings.shift
          scrolling_text = ScrollingTextSprite.new(text, Graphics.width, Graphics.height/2, 640, 3, 2, spriteset.viewport3)
          spriteset.addUserSprite(scrolling_text)
          $last_scrolling_text_time = current_time  # Update the last time
        end
      end
    end
  }
)

def debugScroll
  add_scrolling_text("An Egg has been found by the Day-Care Couple!")
  add_scrolling_text("New items are available at the PokéMart!")
  add_scrolling_text("It might rain tomorrow.")
  add_scrolling_text("Cooltrainer Max is now ready for a rematch.")
end
=end