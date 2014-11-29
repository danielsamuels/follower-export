StaticPopupDialogs["FOLLOWER_EXPORT_POPUP"] = {
  text = "Copy and paste this text into the website.",
  button1 = OKAY,
  timeout = 0,
  whileDead = true,
  hideOnEscape = true,
  hasEditBox = true,
  enterClicksFirstButton = true,
  preferredIndex = 3,
  OnShow = function (self, data)
    self.editBox:SetText(collectData())
    self.editBox:HighlightText()
    self.editBox:SetFocus()
  end,
}

function collectData()
  followers = C_Garrison.GetFollowers()
  output = ''

  local followerData = {}

  for _, follower in pairs(followers) do
    values = {
      follower['name'],
      follower['quality'],
      follower['level'],
      follower['iLevel'],
    }

    if follower['isCollected'] then
      follower.abilities = C_Garrison.GetFollowerAbilities(follower['followerID'])

      for i=1, #follower.abilities do
        local ability = follower.abilities[i];

        if (ability.counters and not ability.isTrait) then
          for id, counter in pairs(ability.counters) do
            table.insert(values, counter.name)
          end
        end

        if ability.isTrait then
          if ability.name == "Epic Mount" or ability.name == "Scavenger" then
            table.insert(values, ability.name)
          end
        end
      end

      table.insert(followerData, table.concat(values, ","))
    end
  end

  return table.concat(followerData, "\\n")
end

SLASH_FOLLOWER_EXPORT1 = '/fe'
SlashCmdList["FOLLOWER_EXPORT"] = function (args)
  StaticPopup_Show("FOLLOWER_EXPORT_POPUP")
end

