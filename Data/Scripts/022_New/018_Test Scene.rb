def testScene
  scene = Test_Scene.new
  screen = Test_Screen.new(scene)
  screen.pbStartScreen
end

class Test_Scene
  def pbStartScene
    @sprites = {}
    @viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport.z = 99999
    addBackgroundPlane(@sprites, "bg", "Generic/Circle bg", @viewport)
    
    @sprites["pokemon"] = PokemonSprite.new(@viewport)
    @sprites["pokemon"].setOffset(PictureOrigin::CENTER)
    @sprites["pokemon"].setPokemonBitmap($player.party[0])
    @sprites["pokemon"].x = Graphics.width/2
    @sprites["pokemon"].y = Graphics.height/2
    @sprites["pokemon"].visible = true
    @sprites["pokemon"].z = 500
    
    
    @sprites["messagebox"] = Window_AdvancedTextPokemon.new("")
    @sprites["messagebox"].z              = 50
    @sprites["messagebox"].viewport       = @viewport
    @sprites["messagebox"].visible        = true
    @sprites["messagebox"].letterbyletter = false
    skinfile = MessageConfig.pbGetSpeechFrame
    @sprites["messagebox"].setSkin(skinfile)
    pbBottomLeftLines(@sprites["messagebox"], 2)
    @sprites["messagebox"].width -= 76*2
    @sprites["messagebox"].text = ("What would you like to do\nwith " + $player.party[0].name + "?")
    commands = [_INTL("Add"), 
                _INTL("Summary"), 
                _INTL("Store"), 
                _INTL("Release")]

    pbShowCommands(commands)
    

  end
  
  def pbUpdate
    @sprites["bg"].oy += 1
    @sprites["bg"].ox -= 1
    #@sprites["bg down"].oy += 1
  end
  
  def pbShowCommands(commands, index = 0)
    ret = -1
    using(cmdwindow = Window_CommandPokemon.new(commands)) do
      cmdwindow.z = @viewport.z + 1
      cmdwindow.index = index
      pbBottomRight(cmdwindow)
      loop do
        Graphics.update
        Input.update
        cmdwindow.update
        pbUpdate
        if Input.trigger?(Input::BACK)
          pbPlayCancelSE
          ret = -1
          break
        elsif Input.trigger?(Input::USE)
          pbPlayDecisionSE
          ret = cmdwindow.index
          break
        end
      end
    end
    return ret
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

class Test_Screen
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

