class Intro_Scene
  
   def pbStartScene
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    @background = pbResolveBitmap("Graphics/UI/Trainer Card/bg_f")
    @sprites["template"] = IconSprite.new(0, 0, @viewport)
    @sprites["template"].setBitmap(_INTL("Graphics/UI/Trainer Card/card_f"))
    @sprites["overlay"] = BitmapSprite.new(Graphics.width, Graphics.height, @viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    @sprites["trainer"] = IconSprite.new(336, 112, @viewport)
    @sprites["trainer"].setBitmap(GameData::TrainerType.player_front_sprite_filename($player.trainer_type))
    @sprites["trainer"].x -= (@sprites["trainer"].bitmap.width - 128) / 2
    @sprites["trainer"].y -= (@sprites["trainer"].bitmap.height - 128)
    @sprites["trainer"].z = 2
    pbBeginIntro
    pbFadeInAndShow(@sprites) { pbUpdate }
  end
  
  def pbBeginIntro
  end
  
  def pbUpdate
  end
  
  def pbScene
    loop do
      Graphics.update
      Input.update
      pbUpdate
      break if Input.trigger?(Input::C)
    end
  end
  
  def pbEndScene
  end
end

class Intro_Screen
  def initialize(scene)
    @scene = scene
  end
  
  def pbStartScreen
    @scene.pbStartScene
    ret = @scene.pbScene
    @scene.pbEndScene
    return ret
  end
end