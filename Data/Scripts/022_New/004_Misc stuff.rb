def honeyAnimation
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999
  viewport.color.red   = 255
  viewport.color.green = 32
  viewport.color.blue  = 32
  viewport.color.alpha -= 10
  start_alpha = viewport.color.alpha
  duration = 1.1
  fade_time = 0.4
  pbWait(duration) do |delta_t|
    if delta_t < duration / 2
      viewport.color.alpha = lerp(start_alpha, start_alpha + 128, fade_time, delta_t)
    else
      viewport.color.alpha = lerp(start_alpha + 128, start_alpha, fade_time, delta_t - duration + fade_time)
    end
  end
  viewport.dispose
end

def honeyCount
end

# exportTilesetsTinted

MenuHandlers.add(:pause_menu, :wait, {
  "name"   => _INTL("Wait"),
  "order"  => 51,  # Adjust the order to your preference
  "effect" => proc { |menu|
    menu.pbHideMenu
    pbPlayDecisionSE

    # Show a message with a choice of 6 elements
    choice = pbMessage(
      _INTL("Wait until when?"),  # Message text
      [_INTL("Dawn"), _INTL("Morning"), _INTL("Day"), 
       _INTL("Dusk"), _INTL("Night"), _INTL("Midnight")],  # Options
      6,  # Number of options
      nil,  # Set a default choice to "Cancel" (no default choice)
      0     # The last option is "Cancel"
    )

    # Perform different actions based on the choice
    case choice
    when 0  # Option 1 (Dawn)
      UnrealTime.advance_to(5, 0, 0)
    when 1  # Option 2 (Morning)
      UnrealTime.advance_to(7, 0, 0)
    when 2  # Option 3 (Day)
      UnrealTime.advance_to(11, 0, 0)
    when 3  # Option 4 (Dusk)
      UnrealTime.advance_to(17, 0, 0)
    when 4  # Option 5 (Night)
      UnrealTime.advance_to(19, 0, 0)
    when 5  # Option 6 (Midnight)
      UnrealTime.advance_to(0, 0, 0)
    when 6  # Cancel (no choice)
      pbPlayDecisionSE
      menu.pbEndScene
      next true
    end
    pbPlayDecisionSE
    #menu.pbRefresh
    #menu.refreshTime
    $game_map.need_tileset_reload = true
    menu.pbEndScene
    next true
    #next false
  }
})
