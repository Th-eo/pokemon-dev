MultipleForms.register(:UNOWN, {
  "getFormOnCreation" => proc { |pkmn|
    caught_forms = $game_variables[32] || []  # Get the array of caught forms
    reroll_count = 0
    
    while true
      selected_form = rand(28)
      
      if caught_forms.include?(selected_form)
        reroll_count += 1
        if reroll_count <= 3
          next  # Reroll if caught, but limit to 3 extra rerolls
        end
      else
        next selected_form  # Use this form if not caught
      end
    end
  }
})
