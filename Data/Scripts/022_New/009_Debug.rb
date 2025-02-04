def giveDebugParty
  party = []
    species = [:BELLOSSOM, :SKARMORY, :MRMIME, :SEEL, :VIBRAVA, :MILTANK]
    species.each { |id| party.push(id) if GameData::Species.exists?(id) }
    $player.party.clear
    # Generate Pokémon of each species at level 20
    party.each do |spec|
      pkmn = Pokemon.new(spec, 30)
      $player.party.push(pkmn)
      $player.pokedex.register(pkmn)
      $player.pokedex.set_owned(spec)
      case spec
      when :SKARMORY
        pkmn.learn_move(:FLY)
        pkmn.item = :ZAPPLATE
      when :MRMIME
        pkmn.learn_move(:FLASH)
        pkmn.learn_move(:TELEPORT)
      when :SEEL
        pkmn.learn_move(:SURF)
        pkmn.learn_move(:DIVE)
        pkmn.learn_move(:WATERFALL)
      when :VIBRAVA
        pkmn.learn_move(:DIG)
        pkmn.learn_move(:CUT)
        pkmn.learn_move(:HEADBUTT)
        pkmn.learn_move(:ROCKSMASH)
      when :MILTANK
        pkmn.learn_move(:SOFTBOILED)
        pkmn.learn_move(:STRENGTH)
        pkmn.learn_move(:SWEETSCENT)
      end
      pkmn.record_first_moves
    end
  end
  
def giveBerries
  $bag.add(:RAZZBERRY,1)
  $bag.add(:BLUKBERRY,1)
  $bag.add(:NANABBERRY,1)
  $bag.add(:WEPEARBERRY,1)
  $bag.add(:PINAPBERRY,1)
end


def generateExpedition
  $game_variables[31] = generateRandomSpeciesArray()
end


# Loads the right character file
def loadUnown
  name = "" #TODO
#  $game_map.events[1].set_character_name(name)
end


def generateRandomSpeciesArray(count=1)
  species_ids = []
  GameData::Species.each_species { |species| species_ids << species.id }
  
  random_species_array = species_ids.sample(count)
  return random_species_array
end

# Method to initiate a battle with a specified Pokémon species ID
def unownBattle(species_id, level = 50)
  # List of possible battleback filenames
  battleback_filenames = [
    "water",
    "city",
    "forest",
    "indoor2",
    # Add more filenames as needed
  ]
  
  # Select a random battleback filename from the list
  random_battleback_filename = battleback_filenames.sample
  
  # Assign the selected filename to $PokemonGlobal.nextBattleBack
  $PokemonGlobal.nextBattleBack = random_battleback_filename

  # Start a battle with the specified species ID and level
  WildBattle.start(species_id, level)
end

