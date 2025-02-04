class FakeTrainerCard_Scene
  
  # Waits x frames
  def wait(frames)
    frames.times do
    Graphics.update
    end
  end
      
  def pbUpdate
    pbUpdateSpriteHash(@sprites)
    if @sprites["bg"]
      @sprites["bg"].ox-=2
      @sprites["bg"].oy-=2
    end
  end
  
  def stars
    return $player.stars
  end

  def pbStartScene
    @front=true
    @flip=false
    @viewport = Viewport.new(0,0,Graphics.width,Graphics.height)
    @viewport.z = 99999
    @sprites = {}
    addBackgroundPlane(@sprites,"bg","Trainer Card/bg",@viewport)
    @sprites["card"] = IconSprite.new(128*2,96*2,@viewport)
    @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_#{$player.stars}")
    @sprites["card"].zoom_x=2 ; @sprites["card"].zoom_y=2
    
    @sprites["card"].ox=@sprites["card"].bitmap.width/2
    @sprites["card"].oy=@sprites["card"].bitmap.height/2
    
    @sprites["bg"].zoom_x=2 ; @sprites["bg"].zoom_y=2
    @sprites["bg"].ox+=6
    @sprites["bg"].oy-=26
    @sprites["overlay"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay"].bitmap)
    
    @sprites["overlay2"] = BitmapSprite.new(Graphics.width,Graphics.height,@viewport)
    pbSetSystemFont(@sprites["overlay2"].bitmap)
    @sprites["overlay2"].y += 6
    
    
    @sprites["overlay"].x=128*2
    @sprites["overlay"].y=96*2 + 6
    @sprites["overlay"].ox=@sprites["overlay"].bitmap.width/2
    @sprites["overlay"].oy=@sprites["overlay"].bitmap.height/2
    
    @sprites["help_overlay"] = IconSprite.new(0,Graphics.height-48,@viewport)
    @sprites["help_overlay"].setBitmap("Graphics/Pictures/Trainer Card/overlay_0")
    @sprites["help_overlay"].zoom_x=2 ; @sprites["help_overlay"].zoom_y=2
    @sprites["trainer"] = IconSprite.new(0,0,@viewport)
    if $player.gender==1
      @sprites["trainer"].setBitmap("Graphics/Pictures/Trainer Card/card_overlay_f")
    else
      @sprites["trainer"].setBitmap("Graphics/Pictures/Trainer Card/card_overlay_m")
    end

    
    @sprites["trainer"].ox=@sprites["trainer"].bitmap.width/2
    @sprites["trainer"].x=128*2
    @sprites["trainer"].opacity = 255

    
    pbDrawTrainerCardFront
    pbFadeInAndShow(@sprites) { pbUpdate }
  end

  
  def flip1
    # "Flip"
    15.times do
      @sprites["overlay"].zoom_y=1.03
      @sprites["card"].zoom_y=2.06
      @sprites["overlay"].zoom_x-=0.1
      @sprites["trainer"].zoom_x-=0.1
      #@sprites["trainer"].x-=12
      @sprites["card"].zoom_x-=0.15
      
      @sprites["overlay"].opacity -= 16
      @sprites["trainer"].opacity -= 16
      
      pbUpdate
      wait(1)
    end
      pbUpdate
  end
  
  def flip2
    # UNDO "Flip"
    15.times do
      @sprites["overlay"].zoom_x+=0.1
      @sprites["trainer"].zoom_x+=0.1
      #@sprites["trainer"].x+=12
      @sprites["card"].zoom_x+=0.15
      @sprites["overlay"].zoom_y=1
      @sprites["card"].zoom_y=2
      
      @sprites["overlay"].opacity += 16
      @sprites["trainer"].opacity += 16
      
      pbUpdate
      wait(1)
    end
      pbUpdate
  end

  def pbDrawTrainerCardFront
    @sprites["overlay"].opacity = 255
    @sprites["trainer"].opacity = 255
    flip1 if @flip==true
    @front=true
    @sprites["trainer"].visible=true
    @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_#{$player.stars}")
    @overlay  = @sprites["overlay"].bitmap
    @overlay2 = @sprites["overlay2"].bitmap
    @overlay.clear
    @overlay2.clear
    baseColor   = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    baseGold = Color.new(255,198,74)
    shadowGold = Color.new(123,107,74)
    if $player.stars==5
      baseColor   = baseGold
      shadowColor = shadowGold
    end
    totalsec = Graphics.frame_count / Graphics.frame_rate
    hour = totalsec / 60 / 60
    min = totalsec / 60 % 60
    time = _ISPRINTF("{1:02d}:{2:02d}",hour,min)
    $PokemonGlobal.startTime = pbGetTimeNow if !$PokemonGlobal.startTime
    starttime = _INTL("{1} {2}, {3}",
       pbGetAbbrevMonthName($PokemonGlobal.startTime.mon),
       $PokemonGlobal.startTime.day,
       $PokemonGlobal.startTime.year)
    textPositions = [
       [_INTL("NAME"),332-60,64-16,0,baseColor,shadowColor],
       [$player.name,302+89*2,64-16,1,baseColor,shadowColor],
       [_INTL("ID No."),32,64-16,0,baseColor,shadowColor],
       [sprintf("%05d",$player.publicID($player.id)),468-122*2,64-16,1,baseColor,shadowColor],
       [_INTL("MONEY"),32,112-16,0,baseColor,shadowColor],
       [_INTL("${1}",$player.money.to_s_formatted),302+2,112-16,1,baseColor,shadowColor],
       [_INTL("BATTLE COINS"),32,112+32,0,baseColor,shadowColor],
       [sprintf("%d",$game_variables[100]),302+2,112+32,1,baseColor,shadowColor],
       [_INTL("SCORE"),32,208,0,baseColor,shadowColor],
       [sprintf("%d",$player.score),302+2,208,1,baseColor,shadowColor],
       [_INTL("TIME"),32,208+48,0,baseColor,shadowColor],
       [time,302+88*2,208+48,1,baseColor,shadowColor],
       [_INTL("ADVENTURE STARTED"),32,256+32,0,baseColor,shadowColor],
       [starttime,302+89*2,256+32,1,baseColor,shadowColor]
    ]
    @sprites["overlay"].z+=10
    pbDrawTextPositions(@overlay,textPositions)
    textPositions = [
      [_INTL("Press F5 to flip the card."),16,64+280,0,Color.new(216,216,216),Color.new(80,80,80)]
    ]
    @sprites["overlay2"].z+=20
    pbDrawTextPositions(@overlay2,textPositions)
    flip2 if @flip==true
  end
  
  def pbDrawTrainerCardBack
    @sprites["overlay"].opacity = 255
    pbUpdate
    @flip=true
    flip1
    @front=false
    @sprites["trainer"].visible=false
    @sprites["card"].setBitmap("Graphics/Pictures/Trainer Card/card_#{$player.stars}b")
    @overlay  = @sprites["overlay"].bitmap
    @overlay2 = @sprites["overlay2"].bitmap
    @overlay.clear
    @overlay2.clear
    baseColor   = Color.new(72,72,72)
    shadowColor = Color.new(160,160,160)
    baseGold = Color.new(255,198,74)
    shadowGold = Color.new(123,107,74)
    if $player.stars==5
      baseColor   = baseGold
      shadowColor = shadowGold
    end
    hof=[]
    if $player.halloffame!=[]
      hof.push(_INTL("{1} {2}, {3}",
      pbGetAbbrevMonthName($player.halloffame[0].mon),
      $player.halloffame[0].day,
      $player.halloffame[0].year))
      hour = $player.halloffame[1] / 60 / 60
      min = $player.halloffame[1] / 60 % 60
      time=_ISPRINTF("{1:02d}:{2:02d}",hour,min)
      hof.push(time)
    else
      hof.push("--- --, ----")
      hof.push("--:--")
    end
    textPositions = [
      [_INTL("HALL OF FAME DEBUT"),32,64-48,0,baseColor,shadowColor],
      [hof[0],302+89*2,64-48,1,baseColor,shadowColor],
      [hof[1],302+89*2,64-16,1,baseColor,shadowColor],
      # These are meant to be Link Battle modes, use as you wish, see below
      #[_INTL(" "),32+111*2,112-16,0,baseColor,shadowColor],
      #[_INTL(" "),32+176*2,112-16,0,baseColor,shadowColor],
      
      [_INTL("W"),32+111*2,112-16+32,0,baseColor,shadowColor],
      [_INTL("L"),32+176*2,112-16+32,0,baseColor,shadowColor],
      
      [_INTL("W"),32+111*2,112-16+64,0,baseColor,shadowColor],
      [_INTL("L"),32+176*2,112-16+64,0,baseColor,shadowColor],
      
      # Customize "$game_variables[100]" to use whatever variable you'd like
      # Some examples: eggs hatched, berries collected,
      # total steps (maybe converted to km/miles? Be creative, dunno!)
      # Pokémon defeated, shiny Pokémon encountered, etc.
      # While I do not include how to create those variables, feel free to HMU
      # if you need some support in the process, or reply to the Relic Castle
      # thread.
      
      [_INTL($player.fullname2),32,112-16,0,baseColor,shadowColor],
      #[_INTL(" ",$game_variables[100]),302+2+50-2,112-16,1,baseColor,shadowColor],
      #[_INTL(" ",$game_variables[100]),302+2+50+63*2,112-16,1,baseColor,shadowColor],
      
      [_INTL("PLACEHOLDER STRING?"),32,112+32-16,0,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[100]),302+2+50-2,112+32-16,1,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[100]),302+2+50+63*2,112+32-16,1,baseColor,shadowColor],
      
      [_INTL("PLACEHOLDER STRING!"),32,112+32-16+32,0,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[100]),302+2+50-2,112+32-16+32,1,baseColor,shadowColor],
      [_INTL("{1}",$game_variables[100]),302+2+50+63*2,112+32-16+32,1,baseColor,shadowColor],
    ]
    @sprites["overlay"].z+=20
    pbDrawTextPositions(@overlay,textPositions)
    textPositions = [
      [_INTL("Press F5 to flip the card."),16,64+280,0,Color.new(216,216,216),Color.new(80,80,80)]
    ]
    @sprites["overlay2"].z+=20
    pbDrawTextPositions(@overlay2,textPositions)
    # Draw Badges on overlay (doesn't support animations, might support .gif)
    imagepos=[]
    # Draw Region 0 badges
    x = 64-28
    for i in 0...8
      if $player.badges[i+0*8]
        imagepos.push(["Graphics/Pictures/Trainer Card/badges0",x,104*2,i*48,0*48,48,48])
      end
      x += 48+8
    end
    # Draw Region 1 badges
    x = 64-28
    for i in 0...8
      if $player.badges[i+1*8]
        imagepos.push(["Graphics/Pictures/Trainer Card/badges1",x,104*2+52,i*48,0*48,48,48])
      end
      x += 48+8
    end
    #print(@sprites["overlay"].ox,@sprites["overlay"].oy,x)
    pbDrawImagePositions(@overlay,imagepos)
    flip2
  end

  def pbTrainerCard
    loop do
      Graphics.update
      Input.update
      pbUpdate
      if Input.trigger?(Input::F5)
        if @front==true
          pbDrawTrainerCardBack 
          wait(3)
        else
          pbDrawTrainerCardFront if @front==false
          wait(3)
        end
      end
      if Input.trigger?(Input::B)
        break
      end
    end 
  end

  def pbEndScene
    pbFadeOutAndHide(@sprites) { pbUpdate }
    pbDisposeSpriteHash(@sprites)
    @viewport.dispose
  end
end



class PokemonTrainerCardScreen
  def initialize(scene)
    @scene = scene
  end

  def pbStartScreen
    @scene.pbStartScene
    @scene.pbTrainerCard
    @scene.pbEndScene
  end
end