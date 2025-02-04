ItemHandlers::UseInField.add(:COINCASE, proc { |item|
  pbMessage(_INTL("Expedition Tokens: <icon=coins> {1}", $player.coins.to_s_formatted))
  next true
})