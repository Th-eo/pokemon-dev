module PBDayNight
  # Dawn 5 AM - 6:59 AM - No lights on  
  def self.Dawn?
    return (pbGetTimeNow.hour >= 5 && pbGetTimeNow.hour < 7)
  end
  
  # 7 AM - 10:59 AM
  def self.Morning?
    return (pbGetTimeNow.hour >= 7 && pbGetTimeNow.hour < 11)
  end
  
  # 11 AM - 4:59 PM
  def self.Day?
    return (pbGetTimeNow.hour >= 11 && pbGetTimeNow.hour < 17)
  end
  
  # 5 PM - 6:59 PM
  def self.Evening?
    return (pbGetTimeNow.hour >= 17 && pbGetTimeNow.hour < 19)
  end
  
  # 7 PM - 10:59 PM
  def self.Night?
    return (pbGetTimeNow.hour >= 19 && pbGetTimeNow.hour < 23)
  end
  
  # Midnight: 11 PM - 4:59 AM - No lights on
  def self.Midnight?
    return (pbGetTimeNow.hour >= 23 || (pbGetTimeNow.hour >= 0 && pbGetTimeNow.hour < 5))
  end
end


module PBDayNight
  HOURLY_TONES = [
      Tone.new(-70, -70, -70, 0),   # Night           # Midnight
      Tone.new(-70, -70, -70, 0),   # Night
      Tone.new(-70, -70, -70, 0),   # Night
      Tone.new(-70, -70, -70, 0),   # Night
      Tone.new(-70, -70, -70, 0),   # Night
      Tone.new(-70, -70, -50, 55),   # Day/morning
      Tone.new(-70, -70, -50, 55),   # Day/morning     # 6AM
      Tone.new(-40, -40, 10, 0),   # Day/morning
      Tone.new(-40, -40, 10, 0),   # Day/morning THIS
      Tone.new(-40, -40, 10, 0),   # Day/morning THIS
      Tone.new(-40, -40, 10, 0),   # Day
      Tone.new(  0,   0,   0,  0),   # Day
      Tone.new(  0,   0,   0,  0),   # Day             # Noon
      Tone.new(  0,   0,   0,  0),   # Day
      Tone.new(  0,   0,   0,  0),   # Day/afternoon
      Tone.new(  0,   0,   0,  0),   # Day/afternoon
      Tone.new(  0,   0,   0,  0),   # Day/afternoon
      Tone.new(40, -40, -30, 0),   # Day/afternoon
      Tone.new(40, -40, -30, 0),   # Day/evening     # 6PM
      Tone.new(-60, -60, -60, 0),   # Day/evening THIS
      Tone.new(-60, -60, -60, 0),   # Day/evening
      Tone.new(-60, -60, -60, 0),   # Night
      Tone.new(-60, -60, -60, 0),   # Night
      Tone.new(-60, -60, -60, 0)    # Night THIS
    ]
end  

def exportTilesetsTinted
  input_folder = "Graphics/Tilesets/Input"
  output_folder = "Graphics/Tilesets/Tinted"

  array = [
    ["_dawn", Tone.new(-70, -70, -50, 55)],
    ["_morning", Tone.new(-40, -40, 10, 0)],
    ["_day", Tone.new(0, 0, 0, 0)],
    ["_evening", Tone.new(40, -40, -30, 0)],
    ["_night", Tone.new(-60, -60, -60, 0)],
    ["_midnight", Tone.new(-70, -70, -70, 0)]
  ]

  # Create the output folder if it doesn't exist
  Dir.mkdir(output_folder) unless File.exist?(output_folder)

  total_exceptions_count = 0  # Initialize a count for all exceptions found

  array.each do |element|
    filename_suffix, tint_tone = element
    Dir.glob("#{input_folder}/*.png").each do |file|
      begin
        # Load the original bitmap
        original_bitmap = RPG::Cache.load_bitmap("", file)

        # Create a new bitmap with the same dimensions
        tinted_bitmap = Bitmap.new(original_bitmap.width, original_bitmap.height)

        total_exceptions_count_in_file = 0  # Initialize a count for exceptions found in the current file

        # Apply the exceptions for evening, morning, and midnight time for each pixel
        for x in 0...original_bitmap.width
          for y in 0...original_bitmap.height
            color = original_bitmap.get_pixel(x, y)
            if color == Color.new(255, 0, 255)
              # Make the magenta color transparent
              tinted_color = Color.new(0, 0, 0, 0)
              total_exceptions_count += 1
              total_exceptions_count_in_file += 1
            elsif filename_suffix == "_evening" || filename_suffix == "_night" || filename_suffix == "_morning"
              # Check for exceptions for evening, morning, and midnight
              if color == Color.new(168, 224, 248)
                tinted_color = Color.new(232, 224, 72)
                total_exceptions_count += 1
                total_exceptions_count_in_file += 1
              elsif color == Color.new(120, 200, 208)
                tinted_color = Color.new(216, 152, 0)
                total_exceptions_count += 1
                total_exceptions_count_in_file += 1
              elsif color == Color.new(216, 240, 248)  # New morning/evening exception
                tinted_color = Color.new(255, 251, 169)
                total_exceptions_count += 1
                total_exceptions_count_in_file += 1
              else
                # Apply the global tone
                r = color.red + tint_tone.red
                g = color.green + tint_tone.green
                b = color.blue + tint_tone.blue
                r = [[r, 0].max, 255].min
                g = [[g, 0].max, 255].min
                b = [[b, 0].max, 255].min
                tinted_color = Color.new(r, g, b)
              end
            elsif filename_suffix == "_midnight"
              # Check for exceptions for midnight
              if color == Color.new(168, 224, 248)
                tinted_color = Color.new(42, 73, 121)
                total_exceptions_count += 1
                total_exceptions_count_in_file += 1
              elsif color == Color.new(120, 200, 208)
                tinted_color = Color.new(20, 35, 66)
                total_exceptions_count += 1
                total_exceptions_count_in_file += 1
              elsif color == Color.new(216, 240, 248)  # New midnight exception
                tinted_color = Color.new(78, 114, 171)
                total_exceptions_count += 1
                total_exceptions_count_in_file += 1
              else
                # Apply the global tone
                r = color.red + tint_tone.red
                g = color.green + tint_tone.green
                b = color.blue + tint_tone.blue
                r = [[r, 0].max, 255].min
                g = [[g, 0].max, 255].min
                b = [[b, 0].max, 255].min
                tinted_color = Color.new(r, g, b)
              end
            else
              # Apply the global tone for other cases
              r = color.red + tint_tone.red
              g = color.green + tint_tone.green
              b = color.blue + tint_tone.blue
              r = [[r, 0].max, 255].min
              g = [[g, 0].max, 255].min
              b = [[b, 0].max, 255].min
              tinted_color = Color.new(r, g, b)
            end

            # Set the pixel with Color.new to ensure consistency
            tinted_bitmap.set_pixel(x, y, tinted_color)
          end
        end

        output_filename = "#{output_folder}/#{File.basename(file, '.png')}#{filename_suffix}.png"
        tinted_bitmap.save_to_png(output_filename)
        tinted_bitmap.dispose
      rescue StandardError => e
        #puts "Error processing #{file}: #{e.message}"
      end
    end
    puts "Finished exporting tinted tilesets"
  end

 # puts "Total exceptions found: #{total_exceptions_count}"  # Display the total exceptions count
end
