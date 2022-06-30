local Config = {}
Config.EnableHeirlooms             = true -- Allow players to obtain heirlooms
Config.EnableGlyphs                = true -- Allow players to obtain glyphs
Config.EnableGems                  = true -- Allow players to obtain gems
Config.EnableContainers            = true -- Allow players to obtain various types of bags
Config.EnableUtilities             = true -- Allow players to perform name change, race change, customization and faction change
Config.EnableApprenticeProfession  = true -- Allow players to increase their profession to skill level 75 of 75
Config.EnableJourneymanProfession  = true -- Allow players to increase their profession to skill level 150 of 150
Config.EnableExpertProfession      = true -- Allow players to increase their profession to skill level 225 of 225
Config.EnableArtisanProfession     = true -- Allow players to increase their profession to skill level 300 of 300
Config.EnableMasterProfession      = true -- Allow players to increase their profession to skill level 375 of 375
Config.EnableGrandMasterProfession = true -- Allow players to increase their profession to skill level 450 of 450
Config.ApprenticeProfessionCost    = 100 -- The cost in gold to increase a profession skill level to 75
Config.JourneymanProfessionCost    = 250 -- The cost in gold to increase a profession skill level to 150
Config.ExpertProfessionCost        = 500 -- The cost in gold to increase a profession skill level to 225
Config.ArtisanProfessionCost       = 750 -- The cost in gold to increase a profession skill level to 300
Config.MasterProfessionCost        = 1250 -- The cost in gold to increase a profession skill level to 375
Config.GrandMasterProfessionCost   = 2500 -- The cost in gold to increase a profession skill level to 450
Config.NameChangeCost              = 10 -- The cost in gold to perform a name change
Config.CustomizeCost               = 50 -- The cost in gold to perform a customization or appearance change
Config.RaceChangeCost              = 500 -- The cost in gold to perform a race chang
Config.FactionChangeCost           = 1000 -- The cost in gold to perform a faction change
Config.Creature                    = 9000000 -- The creature template entry used

local Id        = {
    Return      = 50,
    Heirlooms   = 100,
    Glyphs      = 200,
    Gems        = 300,
    Containers  = 400,
    Utilities   = 400,
    Professions = 500,
}

local Icon   = {
    Chat     = 0, -- white chat bubble
    Vendor   = 1, -- brown bag
    Taxi     = 2, -- flightmarker (paperplane)
    Trainer  = 3, -- brown book (trainer)
    Interact = 4, -- golden interaction wheel
    MoneyBag = 6, -- brown bag (with gold coin in lower corner)
    Talk     = 7, -- white chat bubble (with "..." inside)
    Tabard   = 8, -- white tabard
    Battle   = 9, -- two crossed swords
    Dot      = 10, -- yellow dot/point
}

local Flag        = {
    Rename        = 0x01,
    Customize     = 0x08,
    ChangeFaction = 0x40,
    ChangeRace    = 0x80,
}

local Event        = {
    OnGossipHello  = 1,
    OnGossipSelect = 2,
    OnLogin        = 3,
}

local Class     = {
    Universal   = -1,
    Warrior     = 1,
    Paladin     = 2,
    Hunter      = 3,
    Rogue       = 4,
    Priest      = 5,
    DeathKnight = 6,
    Shaman      = 7,
    Mage        = 8,
    Warlock     = 9,
    Druid       = 11,
}

local Skill        = {
    FirstAid       = 129,
    Blacksmithing  = 164,
    Leatherworking = 165,
    Alchemy        = 171,
    Herbalism      = 182,
    Cooking        = 185,
    Mining         = 186,
    Tailoring      = 197,
    Engineering    = 202,
    Enchanting     = 333,
    Fishing        = 356,
    Skinning       = 393,
    Inscription    = 773,
    Jewelcrafting  = 755,
}

local SkillLevel = {
    Apprentice   = 75,
    Journeyman   = 150,
    Expert       = 225,
    Artisan      = 300,
    Master       = 375,
    GrandMaster  = 450,
}

function Player:HasValidProfession()
    if (Config.EnableApprenticeProfession or Config.EnableJourneymanProfession or Config.EnableExpertProfession or Config.EnableArtisanProfession or Config.EnableMasterProfession or Config.EnableGrandMasterProfession) then
        if (self:IsValidProfession(Skill.FirstAid) or self:IsValidProfession(Skill.Blacksmithing) or self:IsValidProfession(Skill.Leatherworking) or self:IsValidProfession(Skill.Alchemy) or self:IsValidProfession(Skill.Herbalism) or self:IsValidProfession(Skill.Cooking) or self:IsValidProfession(Skill.Mining) or self:IsValidProfession(Skill.Tailoring) or self:IsValidProfession(Skill.Engineering) or self:IsValidProfession(Skill.Enchanting) or self:IsValidProfession(Skill.Fishing) or self:IsValidProfession(Skill.Skinning) or self:IsValidProfession(Skill.Inscription) or self:IsValidProfession(Skill.Jewelcrafting)) then
            return true
        end
    end

    return false
end

function Player:IsValidProfession(skill)
    if (self:HasSkill(skill) and ((self:GetPureSkillValue(skill) < SkillLevel.Apprentice and self:GetPureMaxSkillValue(skill) == SkillLevel.Apprentice and Config.EnableApprenticeProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Journeyman and self:GetPureMaxSkillValue(skill) == SkillLevel.Journeyman and Config.EnableJourneymanProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Expert and self:GetPureMaxSkillValue(skill) == SkillLevel.Expert and Config.EnableExpertProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Artisan and self:GetPureMaxSkillValue(skill) == SkillLevel.Artisan and Config.EnableArtisanProfession) or (self:GetPureSkillValue(skill) < SkillLevel.Master and self:GetPureMaxSkillValue(skill) == SkillLevel.Master and Config.EnableMasterProfession) or (self:GetPureSkillValue(skill) < SkillLevel.GrandMaster and self:GetPureMaxSkillValue(skill) == SkillLevel.GrandMaster and Config.EnableGrandMasterProfession))) then
        return true
    end

    return false
end

function Player:GetProfessionCost(skill)
    local cost = 0
    if (self:GetPureMaxSkillValue(skill) == SkillLevel.Apprentice) then
        cost = Config.ApprenticeProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Journeyman) then
        cost = Config.JourneymanProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Expert) then
        cost = Config.ExpertProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Artisan) then
        cost = Config.ArtisanProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.Master) then
        cost = Config.MasterProfessionCost
    elseif (self:GetPureMaxSkillValue(skill) == SkillLevel.GrandMaster) then
        cost = Config.GrandMasterProfessionCost
    end

    return cost * 10000
end

local function AssistantOnGossipHello(event, player, object)
    player:GossipClearMenu()
    if (Config.EnableHeirlooms) then
        player:GossipMenuAddItem(Icon.Talk, "I want some heirlooms", 1, Id.Heirlooms)
    end
    if (Config.EnableGlyphs) then
        player:GossipMenuAddItem(Icon.Talk, "I want some glyphs", 1, Id.Glyphs)
    end
    if (Config.EnableGems) then
        player:GossipMenuAddItem(Icon.Talk, "I want some gems", 1, Id.Gems)
    end
    if (Config.EnableContainers) then
        player:GossipMenuAddItem(Icon.Talk, "I want some containers", 1, Id.Containers)
    end
    if (Config.EnableUtilities) then
        player:GossipMenuAddItem(Icon.Talk, "I want utilities", 1, Id.Utilities)
    end
    if (player:HasValidProfession()) then
        player:GossipMenuAddItem(Icon.Talk, "I need help with my professions", 1, Id.Professions)
    end
    player:GossipSendMenu(0x7FFFFFFF, object, 1)
end
RegisterCreatureGossipEvent(Config.Creature, Event.OnGossipHello, AssistantOnGossipHello)

local function AssistantOnGossipSelect(event, player, object, sender, intid, code, menu_id)
    if (intid == Id.Return) then
        AssistantOnGossipHello(event, player, object)
    elseif (intid == Id.Heirlooms) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Talk, "I want some weapons", 1, Id.Heirlooms+1)
        player:GossipMenuAddItem(Icon.Talk, "I want some armor", 1, Id.Heirlooms+2)
        player:GossipMenuAddItem(Icon.Talk, "I want something else", 1, Id.Heirlooms+3)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Heirlooms+1) then
        player:SendListInventory(object, Config.Creature)
    elseif (intid == Id.Heirlooms+2) then
        player:SendListInventory(object, Config.Creature+1)
    elseif (intid == Id.Heirlooms+3) then
        player:SendListInventory(object, Config.Creature+2)
    elseif (intid == Id.Glyphs) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Talk, "I want some major glyphs", 1, Id.Glyphs+1)
        player:GossipMenuAddItem(Icon.Talk, "I want some minor glyphs", 1, Id.Glyphs+2)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Glyphs+1) then
        if (player:GetClass() == Class.Warrior) then
            player:SendListInventory(object, Config.Creature+3)
        elseif (player:GetClass() == Class.Paladin) then
            player:SendListInventory(object, Config.Creature+4)
        elseif (player:GetClass() == Class.Hunter) then
            player:SendListInventory(object, Config.Creature+5)
        elseif (player:GetClass() == Class.Rogue) then
            player:SendListInventory(object, Config.Creature+6)
        elseif (player:GetClass() == Class.Priest) then
            player:SendListInventory(object, Config.Creature+7)
        elseif (player:GetClass() == Class.DeathKnight) then
            player:SendListInventory(object, Config.Creature+8)
        elseif (player:GetClass() == Class.Shaman) then
            player:SendListInventory(object, Config.Creature+9)
        elseif (player:GetClass() == Class.Mage) then
            player:SendListInventory(object, Config.Creature+10)
        elseif (player:GetClass() == Class.Warlock) then
            player:SendListInventory(object, Config.Creature+11)
        elseif (player:GetClass() == Class.Druid) then
            player:SendListInventory(object, Config.Creature+12)
        end
    elseif (intid == Id.Glyphs+2) then
        if (player:GetClass() == Class.Warrior) then
            player:SendListInventory(object, Config.Creature+13)
        elseif (player:GetClass() == Class.Paladin) then
            player:SendListInventory(object, Config.Creature+14)
        elseif (player:GetClass() == Class.Hunter) then
            player:SendListInventory(object, Config.Creature+15)
        elseif (player:GetClass() == Class.Rogue) then
            player:SendListInventory(object, Config.Creature+16)
        elseif (player:GetClass() == Class.Priest) then
            player:SendListInventory(object, Config.Creature+17)
        elseif (player:GetClass() == Class.DeathKnight) then
            player:SendListInventory(object, Config.Creature+18)
        elseif (player:GetClass() == Class.Shaman) then
            player:SendListInventory(object, Config.Creature+19)
        elseif (player:GetClass() == Class.Mage) then
            player:SendListInventory(object, Config.Creature+20)
        elseif (player:GetClass() == Class.Warlock) then
            player:SendListInventory(object, Config.Creature+21)
        elseif (player:GetClass() == Class.Druid) then
            player:SendListInventory(object, Config.Creature+22)
        end
    elseif (intid == Id.Gems) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.Talk, "I want some meta gems", 1, Id.Gems+1)
        player:GossipMenuAddItem(Icon.Talk, "I want some red gems", 1, Id.Gems+2)
        player:GossipMenuAddItem(Icon.Talk, "I want some blue gems", 1, Id.Gems+3)
        player:GossipMenuAddItem(Icon.Talk, "I want some yellow gems", 1, Id.Gems+4)
        player:GossipMenuAddItem(Icon.Talk, "I want some purple gems", 1, Id.Gems+5)
        player:GossipMenuAddItem(Icon.Talk, "I want some green gems", 1, Id.Gems+6)
        player:GossipMenuAddItem(Icon.Talk, "I want some orange gems", 1, Id.Gems+7)
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Gems+1) then
        player:SendListInventory(object, Config.Creature+23)
    elseif (intid == Id.Gems+2) then
        player:SendListInventory(object, Config.Creature+24)
    elseif (intid == Id.Gems+3) then
        player:SendListInventory(object, Config.Creature+25)
    elseif (intid == Id.Gems+4) then
        player:SendListInventory(object, Config.Creature+26)
    elseif (intid == Id.Gems+5) then
        player:SendListInventory(object, Config.Creature+27)
    elseif (intid == Id.Gems+6) then
        player:SendListInventory(object, Config.Creature+28)
    elseif (intid == Id.Gems+7) then
        player:SendListInventory(object, Config.Creature+29)
    elseif (intid == Id.Containers) then
        player:SendListInventory(object, Config.Creature+30)
    elseif (intid == Id.Utilities) then
        player:GossipClearMenu()
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my name", 1, Id.Utilities+1, false, "Do you wish to continue the transaction?", (Config.NameChangeCost * 10000))
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my appearance", 1, Id.Utilities+2, false, "Do you wish to continue the transaction?", (Config.CustomizeCost * 10000))
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my race", 1, Id.Utilities+3, false, "Do you wish to continue the transaction?", (Config.RaceChangeCost * 10000))
        player:GossipMenuAddItem(Icon.MoneyBag, "I want to change my faction", 1, Id.Utilities+4, false, "Do you wish to continue the transaction?", (Config.FactionChangeCost * 10000))
        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Utilities+1) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.NameChangeCost * 10000))
            player:SetAtLoginFlag(Flag.Rename)
            player:SendBroadcastMessage("You can now log out to apply the name change.")
            player:GossipComplete()
        end
    elseif (intid == Id.Utilities+2) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.CustomizeCost * 10000))
            player:SetAtLoginFlag(Flag.Customize)
            player:SendBroadcastMessage("You can now log out to apply the customization.")
            player:GossipComplete()
        end
    elseif (intid == Id.Utilities+3) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.RaceChangeCost * 10000))
            player:SetAtLoginFlag(Flag.ChangeRace)
            player:SendBroadcastMessage("You can now log out to apply the race change.")
            player:GossipComplete()
        end
    elseif (intid == Id.Utilities+4) then
        if (player:HasAtLoginFlag(Flag.Rename) or player:HasAtLoginFlag(Flag.Customize) or player:HasAtLoginFlag(Flag.ChangeRace) or player:HasAtLoginFlag(Flag.ChangeFaction)) then
            player:SendBroadcastMessage("You have to complete the previously activated feature before trying to perform another.")
            AssistantOnGossipSelect(event, player, object, sender, Id.Utilities, code)
        else
            player:ModifyMoney(-(Config.FactionChangeCost * 10000))
            player:SetAtLoginFlag(Flag.ChangeFaction)
            player:SendBroadcastMessage("You can now log out to apply the faction change.")
            player:GossipComplete()
        end
    elseif (intid == Id.Professions) then
        player:GossipClearMenu()

        if (player:IsValidProfession(Skill.FirstAid)) then
            local cost = player:GetProfessionCost(Skill.FirstAid)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with First Aid", 1, Id.Professions+1, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Blacksmithing)) then
            local cost = player:GetProfessionCost(Skill.Blacksmithing)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Blacksmithing", 1, Id.Professions+2, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Leatherworking)) then
            local cost = player:GetProfessionCost(Skill.Leatherworking)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Leatherworking", 1, Id.Professions+3, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Alchemy)) then
            local cost = player:GetProfessionCost(Skill.Alchemy)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Alchemy", 1, Id.Professions+4, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Herbalism)) then
            local cost = player:GetProfessionCost(Skill.Herbalism)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Herbalism", 1, Id.Professions+5, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Cooking)) then
            local cost = player:GetProfessionCost(Skill.Cooking)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Cooking", 1, Id.Professions+6, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Mining)) then
            local cost = player:GetProfessionCost(Skill.Mining)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Mining", 1, Id.Professions+7, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Tailoring)) then
            local cost = player:GetProfessionCost(Skill.Tailoring)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Tailoring", 1, Id.Professions+8, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Engineering)) then
            local cost = player:GetProfessionCost(Skill.Engineering)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Engineering", 1, Id.Professions+9, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Enchanting)) then
            local cost = player:GetProfessionCost(Skill.Enchanting)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Enchanting", 1, Id.Professions+10, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Fishing)) then
            local cost = player:GetProfessionCost(Skill.Fishing)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Fishing", 1, Id.Professions+11, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Skinning)) then
            local cost = player:GetProfessionCost(Skill.Skinning)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Skinning", 1, Id.Professions+12, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Inscription)) then
            local cost = player:GetProfessionCost(Skill.Inscription)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Inscription", 1, Id.Professions+13, false, "Do you wish to continue the transaction?", cost)
        end
        if (player:IsValidProfession(Skill.Jewelcrafting)) then
            local cost = player:GetProfessionCost(Skill.Jewelcrafting)
            player:GossipMenuAddItem(Icon.MoneyBag, "I want help with Jewelcrafting", 1, Id.Professions+14, false, "Do you wish to continue the transaction?", cost)
        end

        player:GossipMenuAddItem(Icon.Chat, "Return to the previous page", 1, Id.Return)
        player:GossipSendMenu(0x7FFFFFFF, object, 1)
    elseif (intid == Id.Professions+1) then
        local cost = player:GetProfessionCost(Skill.FirstAid)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.FirstAid, 0, player:GetMaxSkillValue(Skill.FirstAid), player:GetMaxSkillValue(Skill.FirstAid))
        player:GossipComplete()
    elseif (intid == Id.Professions+2) then
        local cost = player:GetProfessionCost(Skill.Blacksmithing)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Blacksmithing, 0, player:GetMaxSkillValue(Skill.Blacksmithing), player:GetMaxSkillValue(Skill.Blacksmithing))
        player:GossipComplete()
    elseif (intid == Id.Professions+3) then
        local cost = player:GetProfessionCost(Skill.Leatherworking)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Leatherworking, 0, player:GetMaxSkillValue(Skill.Leatherworking), player:GetMaxSkillValue(Skill.Leatherworking))
        player:GossipComplete()
    elseif (intid == Id.Professions+4) then
        local cost = player:GetProfessionCost(Skill.Alchemy)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Alchemy, 0, player:GetMaxSkillValue(Skill.Alchemy), player:GetMaxSkillValue(Skill.Alchemy))
        player:GossipComplete()
    elseif (intid == Id.Professions+5) then
        local cost = player:GetProfessionCost(Skill.Herbalism)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Herbalism, 0, player:GetMaxSkillValue(Skill.Herbalism), player:GetMaxSkillValue(Skill.Herbalism))
        player:GossipComplete()
    elseif (intid == Id.Professions+6) then
        local cost = player:GetProfessionCost(Skill.Cooking)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Cooking, 0, player:GetMaxSkillValue(Skill.Cooking), player:GetMaxSkillValue(Skill.Cooking))
        player:GossipComplete()
    elseif (intid == Id.Professions+7) then
        local cost = player:GetProfessionCost(Skill.Mining)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Mining, 0, player:GetMaxSkillValue(Skill.Mining), player:GetMaxSkillValue(Skill.Mining))
        player:GossipComplete()
    elseif (intid == Id.Professions+8) then
        local cost = player:GetProfessionCost(Skill.Tailoring)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Tailoring, 0, player:GetMaxSkillValue(Skill.Tailoring), player:GetMaxSkillValue(Skill.Tailoring))
        player:GossipComplete()
    elseif (intid == Id.Professions+9) then
        local cost = player:GetProfessionCost(Skill.Engineering)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Engineering, 0, player:GetMaxSkillValue(Skill.Engineering), player:GetMaxSkillValue(Skill.Engineering))
        player:GossipComplete()
    elseif (intid == Id.Professions+10) then
        local cost = player:GetProfessionCost(Skill.Enchanting)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Enchanting, 0, player:GetMaxSkillValue(Skill.Enchanting), player:GetMaxSkillValue(Skill.Enchanting))
        player:GossipComplete()
    elseif (intid == Id.Professions+11) then
        local cost = player:GetProfessionCost(Skill.Fishing)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Fishing, 0, player:GetMaxSkillValue(Skill.Fishing), player:GetMaxSkillValue(Skill.Fishing))
        player:GossipComplete()
    elseif (intid == Id.Professions+12) then
        local cost = player:GetProfessionCost(Skill.Skinning)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Skinning, 0, player:GetMaxSkillValue(Skill.Skinning), player:GetMaxSkillValue(Skill.Skinning))
        player:GossipComplete()
    elseif (intid == Id.Professions+13) then
        local cost = player:GetProfessionCost(Skill.Inscription)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Inscription, 0, player:GetMaxSkillValue(Skill.Inscription), player:GetMaxSkillValue(Skill.Inscription))
        player:GossipComplete()
    elseif (intid == Id.Professions+14) then
        local cost = player:GetProfessionCost(Skill.Jewelcrafting)
        player:ModifyMoney(-cost)
        player:SetSkill(Skill.Jewelcrafting, 0, player:GetMaxSkillValue(Skill.Jewelcrafting), player:GetMaxSkillValue(Skill.Jewelcrafting))
        player:GossipComplete()
    end
end
RegisterCreatureGossipEvent(Config.Creature, Event.OnGossipSelect, AssistantOnGossipSelect)
