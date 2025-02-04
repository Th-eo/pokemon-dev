def doBridges
  $game_variables[1] ||= $game_player.x
  $game_variables[2] ||= $game_player.y

  player_x = $game_player.x
  player_y = $game_player.y
  prev_player_x = $game_variables[1]
  prev_player_y = $game_variables[2]

  if player_x != prev_player_x || player_y != prev_player_y
    for event in $game_map.events.values
      if event.name == "Bridge" && event.id != $game_player.id
        x = event.x

          if x == player_x
            if prev_player_x < player_x
              # Player moved right onto the event
              event.turn_left
              event.turn_up
            elsif prev_player_x > player_x
              # Player moved left onto the event
              event.turn_right
              
              # Change graphic for a few frames
              original_graphic = event.character_name  # Store the original graphic
              event.character_name = "Object Bridge From Left"
              
              animation_frames = 20  # Adjust the number of frames as needed
          
              # Pause the event for the specified duration before turning up
              animation_frames.times do
              #  pbWait(1)  # Wait for 1 frame (adjust as needed)
              end
          
              # Restore the original graphic
              event.character_name = original_graphic
          
              # Then turn up
              event.turn_up
            end
          else
            event.turn_down
          end

      end
    end


    $game_variables[1] = player_x
    $game_variables[2] = player_y
  end
end
