def testScene
  scene = Test_Scene.new
  screen = Test_Screen.new(scene)
  screen.pbStartScreen
end

class Test_Scene
  def pbStartScene
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

