
# in class Game_Map, find `tileset = $data_tilesets[@map.tileset_id]`
# and change it to
#    self.refresh_tilesets
#    tileset = $data_tilesets[@cached_tileset]
# find `play_now = $stats.play_time` and put `self.refresh_tilesets` below it
# I LOVE VENDILY SO MUCH
# green heart emoji (ogre heart)
class Game_Map
  TOD_Tileset_IDs = {
    31 => { 
    :dawn => 32,  
    :morning => 33,  
    :evening => 34,
    :night => 35,  
    :midnight => 36
    }
  }
  CACHED_TILESET_LIFETIME = 1
  
  attr_accessor :need_tileset_reload
  attr_accessor :tilesets_refreshed_flag
  def tileset_id;     return @cached_tileset || @map.tileset_id;  end

  def get_tileset_id
    ret = @map.tileset_id
    tilesets = TOD_Tileset_IDs[@map.tileset_id]
    return ret unless tilesets
    if PBDayNight.Day?
      try_time = :day
    elsif PBDayNight.Dawn?
      try_time = :dawn
    elsif PBDayNight.Morning?
      try_time = :morning
    elsif PBDayNight.Evening?
      try_time = :evening
    elsif PBDayNight.Night?
      try_time = :night
    elsif PBDayNight.Midnight?
      try_time = :midnight
    end
    try_time = :day unless try_time
    ret = tilesets[try_time] if tilesets[try_time]
    #else
    #  try_time = :night
    #  ret = tilesets[try_time] if tilesets[try_time]
    #puts "#{try_time} #{ret} #{PBDayNight.Dawn?} #{PBDayNight.Morning?} #{PBDayNight.Day?} #{PBDayNight.Evening?} #{PBDayNight.Night?} #{PBDayNight.Midnight?}"
    return ret
  end
  
  def refresh_tilesets
    @cached_tileset = @map.tileset_id if !@cached_tileset
    if !@dayNightTilesetLastUpdate || (System.uptime - @dayNightTilesetLastUpdate >= CACHED_TILESET_LIFETIME)
      tileset = get_tileset_id
      if @cached_tileset != tileset
        @cached_tileset = tileset
        self.updateTileset
        self.need_tileset_reload = true
        # Add code here to turn off @door_tinted in all door events
        # Notify the callback that tilesets are refreshed
        PBDayNight.on_tilesets_refreshed_callback
      end
      @dayNightTilesetLastUpdate = System.uptime
    end
  end

end

def timeSuffix
  if PBDayNight.Day?
      try_time = ""
    elsif PBDayNight.Dawn?
      try_time = "_dawn"
    elsif PBDayNight.Morning?
      try_time = "_morning"
    elsif PBDayNight.Evening?
      try_time = "_evening"
    elsif PBDayNight.Night?
      try_time = "_night"
    elsif PBDayNight.Midnight?
      try_time = "_midnight"
    end
    return try_time
end

class Spriteset_Map
  def refresh_tileset
    return unless $scene.is_a?(Scene_Map)
    return unless @map.need_tileset_reload
    $scene.map_renderer.remove_tileset(@map.tileset_name)
    @map.autotile_names.each { |filename| $scene.map_renderer.remove_autotile(filename) }
    $scene.map_renderer.remove_extra_autotiles(@map.tileset_id)
    $scene.map_renderer.add_tileset(@map.tileset_name)
    @map.autotile_names.each { |filename|
      #filename+=timeSuffix
      $scene.map_renderer.add_autotile(filename)
    }
    $scene.map_renderer.add_extra_autotiles(@map.tileset_id)
    $scene.map_renderer.refresh
    $scene.map_renderer.update
    @map.need_tileset_reload = false
  end
  
  alias _todt_update update
  def update
    refresh_tileset
    _todt_update
  end
end

