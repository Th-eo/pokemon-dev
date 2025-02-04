SILLY_TEXT = "Bill's words echoed... Now is not the time for that!"

ItemHandlers::CanUseInBattle.add(:RAZZBERRY, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if $game_variables[27][0] == true
    scene.pbDisplay(_INTL(SILLY_TEXT))
    next false
  else
    next true
  end
  
})

ItemHandlers::CanUseInBattle.add(:BLUKBERRY, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if $game_variables[27][1] == true
    scene.pbDisplay(_INTL(SILLY_TEXT))
    next false
  else
    next true
  end
})

ItemHandlers::CanUseInBattle.add(:NANABBERRY, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if $game_variables[27][2] == true
    scene.pbDisplay(_INTL(SILLY_TEXT))
    next false
  else
    next true
  end
})

ItemHandlers::CanUseInBattle.add(:WEPEARBERRY, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if $game_variables[27][3] == true
    scene.pbDisplay(_INTL(SILLY_TEXT))
    next false
  else
    next true
  end
})

ItemHandlers::CanUseInBattle.add(:PINAPBERRY, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if $game_variables[27][4] == true
    scene.pbDisplay(_INTL(SILLY_TEXT))
    next false
  else
    next true
  end
})


ItemHandlers::UseInBattle.add(:RAZZBERRY, proc { |item, battler, battle|
  battle.pbThrowBerry(battler.index, item)
})

ItemHandlers::UseInBattle.copy(:RAZZBERRY, :BLUKBERRY, :NANABBERRY, :WEPEARBERRY, :PINAPBERRY)


class Battle
  # Throw Berry
  def pbThrowBerry(idxBattler, item)
    # Determine which Pokémon you're throwing the Poké Ball at
    battler = nil
    if opposes?(idxBattler)
      battler = @battlers[idxBattler]
    else
      battler = @battlers[idxBattler].pbDirectOpposing(true)
    end
    battler = battler.allAllies[0] if battler.fainted?
    # Messages
    itemName = GameData::Item.get(item).name
    if battler.fainted?
      if itemName.starts_with_vowel?
        pbDisplay(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
      else
        pbDisplay(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
      end
      pbDisplay(_INTL("But there was no target..."))
      return
    end
    if itemName.starts_with_vowel?
      pbDisplayBrief(_INTL("{1} threw an {2}!", pbPlayer.name, itemName))
    else
      pbDisplayBrief(_INTL("{1} threw a {2}!", pbPlayer.name, itemName))
    end
    # Todo or skip? Deflecting the Berry
    # Animation of opposing trainer blocking Poké Balls (unless it's a Snag Ball
    # at a Shadow Pokémon)
    #if trainerBattle?
    #  @scene.pbThrowAndDeflect(item, 1)
    #  pbDisplay(_INTL("The Trainer blocked your Berry! Don't be silly!"))
    #  return
    #end

    # Do Berry stuff
    pkmn = battler.pokemon
    case item
    when :RAZZBERRY
      throw = 0
      $game_variables[27][0] = true
    when :BLUKBERRY
      throw = 1
      $game_variables[27][1] = true
    when :NANABBERRY
      throw = 2
      $game_variables[27][2] = true
    when :WEPEARBERRY
      throw = 3
      $game_variables[27][3] = true
    when :PINAPBERRY
      throw = 4
      $game_variables[27][4] = true
    end
    @scene.pbThrowBerry(throw)
    case item
    when :RAZZBERRY
      pbDisplay(_INTL("The wild {1} is distracted!", battler.name))
    when :BLUKBERRY
      pbDisplay(_INTL("The wild {1} braced itself!", battler.name))
      battler.effects[PBEffects::BlukBerry] = 2
      battler.pbRaiseStatStage(:ATTACK, 1, battler, showAnim = true, ignoreContrary = true)
      battler.pbRaiseStatStage(:SPECIAL_ATTACK, 1, battler, showAnim = true, ignoreContrary = true)
    when :NANABBERRY
      pbDisplay(_INTL("The wild {1} calmed down.", battler.name))
      battler.pbLowerStatStage(:ATTACK, 1, battler, showAnim = true, ignoreContrary = true)
      battler.pbLowerStatStage(:SPECIAL_ATTACK, 1, battler, showAnim = true, ignoreContrary = true)
    when :WEPEARBERRY
      pbDisplay(_INTL("The wild {1} is excited!", battler.name))
      battler.pbRaiseStatStage(:ATTACK, 1, battler, showAnim = true, ignoreContrary = true)
      battler.pbRaiseStatStage(:SPECIAL_ATTACK, 1, battler, showAnim = true, ignoreContrary = true)
    when :PINAPBERRY
      pbDisplay(_INTL("The wild {1} is acting clumsily!", battler.name))
    end
  end
end

#===============================================================================
# Shows the player throwing bait at a wild Pokémon in a Safari battle.
#===============================================================================
class Battle::Scene::Animation::ThrowBerry < Battle::Scene::Animation
  include Battle::Scene::Animation::BallAnimationMixin

  def initialize(sprites, viewport, battler, berry)
    @battler = battler
    @trainer = battler.battle.pbGetOwnerFromBattlerIndex(battler.index)
    @berry = berry
    super(sprites, viewport)
  end

  def createProcesses
    # Calculate start and end coordinates for battler sprite movement
    batSprite = @sprites["pokemon_#{@battler.index}"]
    traSprite = @sprites["pokemon_#0"]
    ballPos = Battle::Scene.pbBattlerPosition(@battler.index, batSprite.sideSize)
    ballStartX = 128
    ballStartY = 208
    ballMidX   = 0   # Unused in arc calculation
    ballMidY   = 122
    ballEndX   = ballPos[0] - 40
    ballEndY   = ballPos[1] - 4
    # Set up bait sprite
    ball = addNewSprite(ballStartX, ballStartY,
                        "Graphics/Battle animations/berry"+@berry.to_s, PictureOrigin::CENTER)
    ball.setZ(0, batSprite.z + 1)
    delay = ball.totalDuration   # 0 or 7
    # Bait arc animation
    ball.setSE(delay, "Battle throw")
    createBallTrajectory(ball, delay, 12,
                         ballStartX, ballStartY, ballMidX, ballMidY, ballEndX, ballEndY)
    ball.setZ(9, batSprite.z + 1)
    delay = ball.totalDuration
    ball.moveOpacity(delay + 8, 2, 0)
    ball.setVisible(delay + 10, false)
    # Set up battler sprite
    battler = addSprite(batSprite, PictureOrigin::BOTTOM)
    # Show Pokémon jumping before eating the bait
    delay = ball.totalDuration + 3
    2.times do
      battler.setSE(delay, "player jump")
      battler.moveDelta(delay, 3, 0, -16)
      battler.moveDelta(delay + 4, 3, 0, 16)
      delay = battler.totalDuration + 1
    end
    # Show Pokémon eating the bait
    delay = battler.totalDuration + 3
    2.times do
      battler.moveAngle(delay, 7, 5)
      battler.moveDelta(delay, 7, 0, 6)
      battler.moveAngle(delay + 7, 7, 0)
      battler.moveDelta(delay + 7, 7, 0, -6)
      delay = battler.totalDuration
    end
  end
end

class Battle::Scene
  def pbThrowBerry(berry)
    @briefMessage = false
    baitAnim = Animation::ThrowBerry.new(@sprites, @viewport, @battle.battlers[1], berry)
    loop do
      baitAnim.update
      pbUpdate
      break if baitAnim.animDone?
    end
    baitAnim.dispose
  end
end


# Dropped item due to Pinap Berry

#===============================================================================
# Picking up an item found on the ground
#===============================================================================
def pbItemDrop(item, quantity = 1)
  item = GameData::Item.get(item)
  return false if !item || quantity < 1
  itemname = (quantity > 1) ? item.portion_name_plural : item.portion_name
  pocket = item.pocket
  move = item.move
  if $bag.add(item, quantity)   # If item can be picked up
    meName = (item.is_key_item?) ? "Key item get" : "Item get"
    if item == :DNASPLICERS
      pbMessage("\\me[#{meName}]" + _INTL("You found \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[30]")
    elsif item.is_machine?   # TM or HM
      if quantity > 1
        pbMessage("\\me[#{meName}]" + _INTL("You found {1} \\c[1]{2} {3}\\c[0]!",
                                            quantity, itemname, GameData::Move.get(move).name) + "\\wtnp[30]")
      else
        pbMessage("\\me[#{meName}]" + _INTL("You found \\c[1]{1} {2}\\c[0]!",
                                            itemname, GameData::Move.get(move).name) + "\\wtnp[30]")
      end
    elsif quantity > 1
      pbMessage("\\me[#{meName}]" + _INTL("You found {1} \\c[1]{2}\\c[0]!", quantity, itemname) + "\\wtnp[30]")
    elsif itemname.starts_with_vowel?
      pbMessage("\\me[#{meName}]" + _INTL("You found an \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[30]")
    else
      pbMessage("\\me[#{meName}]" + _INTL("You found a \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[30]")
    end
    pbMessage(_INTL("You put the {1} in\\nyour Bag's <icon=bagPocket{2}>\\c[1]{3}\\c[0] pocket.",
                    itemname, pocket, PokemonBag.pocket_names[pocket - 1]))
    return true
  end
  # Can't add the item
  if item.is_machine?   # TM or HM
    if quantity > 1
      pbMessage(_INTL("You found {1} \\c[1]{2} {3}\\c[0]!", quantity, itemname, GameData::Move.get(move).name) + "\\wtnp[30]")
    else
      pbMessage(_INTL("You found \\c[1]{1} {2}\\c[0]!", itemname, GameData::Move.get(move).name) + "\\wtnp[30]")
    end
  elsif quantity > 1
    pbMessage(_INTL("You found {1} \\c[1]{2}\\c[0]!", quantity, itemname) + "\\wtnp[30]")
  elsif itemname.starts_with_vowel?
    pbMessage(_INTL("You found an \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[30]")
  else
    pbMessage(_INTL("You found a \\c[1]{1}\\c[0]!", itemname) + "\\wtnp[30]")
  end
  pbMessage(_INTL("But your Bag is full..."))
  return false
end