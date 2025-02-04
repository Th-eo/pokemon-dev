# Define the tiles you want to load
Bridge = [
  [],
  [
    1584, 1585, 1586, 1587, 1588,
    1592, 1593, 1594, 1595, 1596,
    1592, 1593, 1594, 1595, 1596,
    1600, 1601, 1602, 1603, 1604,
    1608, 1609, 1610, 1611, 1612
  ],
  []
]

# Modified method to load tiles onto the map in a 5x5 grid
def loadTilesOnto(map, tile_data, target_x, target_y, width, height)
  map_width = map.width
  map_height = map.height

  tile_data.each_with_index do |layer_data, layer|
    layer_data.each_with_index do |tile_id, index|
      x = target_x + (index % width)  # Calculate the X position based on the index and wrap it to a 5-wide grid
      y = target_y + (index / height).floor  # Calculate the Y position based on the index and wrap it to a 5x5 grid

      # Check if the target XY position is within the map boundaries
      if x >= 0 && x < map_width && y >= 0 && y < map_height
        map.data[x, y, layer] = tile_id
      end
    end
  end
end

# Add an event handler to load tiles when the switch is on
#EventHandlers.add(:on_game_map_setup, :map_load_bridge,
#  proc { |map_id, map, _tileset_data|
#  if $game_switches[76]  # Replace YOUR_SWITCH_ID with the actual switch ID
#    loadTilesOnto(map, Bridge, 9, 5, 5, 5)
#  end
# } 
#)



def fade_and_reload_map(map_id)
      pbFadeOutIn { Graphics.wait(20)  # Wait for the fade to complete

      $game_temp.player_new_map_id    = $game_map.map_id
      $game_temp.player_new_x         = $game_player.x
      $game_temp.player_new_y         = $game_player.y
      $scene.transfer_player

      pbCancelVehicles
      $map_factory.setup($game_map.map_id)
      $game_map.update
      $game_map.autoplay
      $game_temp.followers.map_transfer_followers
      #$game_map.update
      #$scene.disposeSpritesets
      #RPG::Cache.clear
      #$scene.createSpritesets
                  $game_player.center($game_player.x, $game_player.y)
      #$game_map.autoplay
      if $scene.is_a?(Scene_Map)
        $scene.dispose
        $scene.createSpritesets
      end   
      Graphics.frame_reset
      
      #$game_map.autoplay
      #Graphics.frame_reset
      #Input.update
      
  
  Graphics.wait(80) 
  }# Wait for the fade to complete
end


  def exportTilesets
    input_folder = "Graphics/Tilesets"
    output_folder = "Graphics/Tilesets/Numbered"
    font_size = 14 
    font_color = Color.new(255, 255, 255)
    
    outline_colors = [
      Color.new(0, 0, 0),
      Color.new(0, 0, 0),
    ]
    
    outline_offsets = [
      [-1, -1], [-1, 0], [-1, 1],
      [0, -1],            [0, 1],
      [1, -1],   [1, 0],  [1, 1]
    ]
    
    Dir.glob("#{input_folder}/*.png").each do |file|
      tileset = RPG::Cache.load_bitmap("", file)
      numbered_tileset = Bitmap.new(tileset.width, tileset.height)
    
      # Starting tile number, before its autotiles
      tile_number = 384
    
      # Iterate through tileset and draw tile number
      for y in 0...(tileset.height / 32)
        for x in 0...(tileset.width / 32)
          tile_rect = Rect.new(x * 32, y * 32, 32, 32)
          numbered_tileset.blt(x * 32, y * 32, tileset, tile_rect)
          outline_colors.each do |outline_color|
            outline_offsets.each do |offset|
              text_x = x * 32 + 16 + offset[0] - 16
              text_y = y * 32 + 16 + offset[1] - 16 + 6
              numbered_tileset.font.color = outline_color
              numbered_tileset.draw_text(text_x, text_y, 32, 32, tile_number.to_s, 1)
            end
          end
    
          text_x = x * 32 + 16 - 16
          text_y = y * 32 + 16 - 16 + 6
          numbered_tileset.font.color = font_color
          numbered_tileset.draw_text(text_x, text_y, 32, 32, tile_number.to_s, 1)
    
          tile_number += 1
        end
      end
    
      output_filename = "#{output_folder}/#{File.basename(file)}"
      numbered_tileset.save_to_png(output_filename)
      tileset.dispose
      numbered_tileset.dispose
    end
  end
  

