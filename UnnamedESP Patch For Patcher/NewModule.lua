    [5208655184] = {
        CustomPlayerTag = function(Player)
            if game.PlaceVersion < 457 then return '' end
            local Name = '';
            local FirstName = Player:GetAttribute'FirstName'
            if typeof(FirstName) == 'string' and #FirstName > 0 then
                local Prefix = '';
                local Extra = {};
                local Extra2 = {};
                Name = Name .. '\n[';

                if Player:GetAttribute'Prestige' > 0 then
                    Name = Name .. '#' .. tostring(Player:GetAttribute'Prestige') .. ' ';
                end
                if not IsStringEmpty(Player:GetAttribute'HouseRank') then
                    Prefix = Player:GetAttribute'HouseRank' == 'Owner' and (Player:GetAttribute'Gender' == 'Female' and 'Lady ' or 'Lord ') or '';
                end
                if not IsStringEmpty(FirstName) then
                    Name = Name .. '' .. Prefix .. FirstName;
                end
                if not IsStringEmpty(Player:GetAttribute'LastName') then
                    Name = Name .. ' ' .. Player:GetAttribute'LastName';
                end

                if not IsStringEmpty(Name) then Name = Name .. ']'; end

                local Character = GetCharacter(Player);

                if Character then
                    if Character and Character:FindFirstChild'Danger' then table.insert(Extra, 'In Danger'); end
                    if Character:FindFirstChild'ManaAbilities' and Character.ManaAbilities:FindFirstChild'ManaSprint' then table.insert(Extra, '1+ Day'); end
                    if Character:FindFirstChild'Mana'	 		then table.insert(Extra, 'M' .. math.floor(Character.Mana.Value)); end
                    --[[]]
                    if Character:FindFirstChild'Vampirism' and not Player.Backpack:FindFirstChild("EnhancedVampirism") 		then table.insert(Extra, 'Vampirism'); end
                    if Character:FindFirstChild'Vampirism' and     Player.Backpack:FindFirstChild("EnhancedVampirism") 		then table.insert(Extra, 'Enhanced Vampirism'); end

                    if Player:FindFirstChild'Backpack' then
                        local player_class = "Freshie"
                        local class_tier = "Base"
                        local player_class2 = "None"

                        if (Player.Backpack:FindFirstChild"Interrogation" or Player.Backpack:FindFirstChild"Silverguard" and not (Player.Backpack:FindFirstChild"Portable Smithing" or Player.Backpack:FindFirstChild"Grindstone")) and class_tier ~= "Ultra" then
                            player_class = "Spy"
                            class_tier = "Super"
                            if Player.Backpack:FindFirstChild"Elegant Slash" or Player.Backpack:FindFirstChild"Needle's Eye"then
                                class_tier = "Ultra"
                                player_class = "Whisperer(Soul)"
                                if Player.Backpack:FindFirstChild"The Wraith" then
                                    player_class = "Whisperer(Wraith)"
                                elseif Player.Backpack:FindFirstChild"The Shadow" then
                                    player_class = "Whisperer(Shadow)"
                                end
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Lethality" or Player.Backpack:FindFirstChild"Bane" or Player.Backpack:FindFirstChild"Triple Dagger Throw") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Assassin"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Assassin"
                            end
                            if Player.Backpack:FindFirstChild"Grapple" or Player.Backpack:FindFirstChild"Shadowrush" or Player.Backpack:FindFirstChild"Resurrection" then
                                class_tier = "Ultra"
                                player_class = "Shinobi"
                            elseif Player.Backpack:FindFirstChild"Shadow Fan" or Player.Backpack:FindFirstChild"Ethereal Strike" then
                                class_tier = "Ultra"
                                player_class = "Faceless"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Claritum" or Player.Backpack:FindFirstChild"Custos") and class_tier ~= "Ultra" then
                            local has_Observe = false
                            if Player.Backpack:FindFirstChild"Observe" then
                                has_Observe = true
                            end
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                if not has_Observe then
                                    player_class = "Illusionist(No Observe)"
                                    class_tier = "Hybrid"
                                else
                                    player_class = "Illusionist"
                                end
                            elseif class_tier == "Super" then
                                if not has_Observe then
                                    player_class2 = "Illusionist(No Observe)"
                                else
                                    player_class2 = "Illusionist"
                                end
                            end
                            if Player.Backpack:FindFirstChild"Globus" or Player.Backpack:FindFirstChild"Intermissum" or Player.Backpack:FindFirstChild"Dominus" then
                                class_tier = "Ultra"
                                player_class = "Master Illusionist"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Fons Vitae" or Player.Backpack:FindFirstChild"Verdien") and class_tier ~= "Ultra" then
                            local has_Life_Sense = false
                            if Player.Backpack:FindFirstChild"Life Sense" then
                                has_Life_Sense = true
                            end
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                if not has_Life_Sense then
                                    player_class = "Botanist(No Life Sense)"
                                    class_tier = "Hybrid"
                                else
                                    player_class = "Botanist"
                                end
                            elseif class_tier == "Super" then
                                if not has_Life_Sense then
                                    player_class2 = "Botanist(No Life Sense)"
                                else
                                    player_class2 = "Botanist"
                                end
                            end
                            if Player.Backpack:FindFirstChild"Perflora" or Player.Backpack:FindFirstChild"Floresco" then
                                class_tier = "Ultra"
                                player_class = "Druid"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Inferi" or Player.Backpack:FindFirstChild"Reditus" or Player.Backpack:FindFirstChild"Ligans" or Player.Backpack:FindFirstChild"Vocare") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Necromancer"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Necromancer"
                            end
                            if Player.Backpack:FindFirstChild"Secare" or Player.Backpack:FindFirstChild"Furantur" or Player.Backpack:FindFirstChild"Command Monsters" or Player.Backpack:FindFirstChild"Howler Summoning" then
                                class_tier = "Ultra"
                                player_class = "Master Necromancer"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Harpoon" or Player.Backpack:FindFirstChild"Skewer" or Player.Backpack:FindFirstChild"Hunter\'s Focus") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Spearfisher"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Spearfisher"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Impale" or Player.Backpack:FindFirstChild"Light Piercer") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Church Knight"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Church Knight"
                            end
                            if Player.Backpack:FindFirstChild"Deep Sacrifice" or Player.Backpack:FindFirstChild"Leviathans Plunge" or Player.Backpack:FindFirstChild"Chain Pull" then
                                class_tier = "Ultra"
                                player_class = "Deep Knight"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Spear Crusher" or Player.Backpack:FindFirstChild"Dragon Roar" or Player.Backpack:FindFirstChild"Dragon Blood") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Dragon Knight"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Dragon Knight"
                            end
                            if Player.Backpack:FindFirstChild"Wing Soar" or Player.Backpack:FindFirstChild"Thunder Spear Crash" or Player.Backpack:FindFirstChild"Dragon Awakening" then
                                class_tier = "Ultra"
                                player_class = "Dragon Slayer"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Flame Charge" or Player.Backpack:FindFirstChild"Ice Charge" or Player.Backpack:FindFirstChild"Thunder Charge") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Sigil Knight"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Sigil Knight"
                            end

                            if Player.Backpack:FindFirstChild"Charged Blow" or Player.Backpack:FindFirstChild"Hyper Body" then
                                class_tier = "Ultra"
                                player_class = "Sigil Knight Commander"
                                if Player.Backpack:FindFirstChild"White Flame Charge" then
                                    player_class = "Sigil Knight Commander(Solan)"
                                end
                            end
                        end
                        if (Player.Backpack:FindFirstChild"Soul Rip" and (Player.Backpack:FindFirstChild"Dark Flame Burst" or Player.Backpack:FindFirstChild"Dark Eruption")) and class_tier ~= "Ultra" then
                            player_class = "Wraith Knight"
                        end

                        if (Player.Backpack:FindFirstChild"Portable Smithing" or Player.Backpack:FindFirstChild"Grindstone") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Advanced Smith"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Advanced Smith"
                            end
                            if Player.Backpack:FindFirstChild"Silverguard" then
                                class_tier = "Ultra"
                                player_class = "Lapidarist"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Triple Slash" or Player.Backpack:FindFirstChild"Blade Flash" or Player.Backpack:FindFirstChild"Flowing Counter") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Samurai"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Samurai"
                            end
                            if Player.Backpack:FindFirstChild"Swallow Reversal" or Player.Backpack:FindFirstChild"Calm Mind" then
                                class_tier = "Ultra"
                                player_class = "Ronin"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Monastic Stance") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Monk"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Monk"
                            end

                            if Player.Backpack:FindFirstChild"Lightning Drop" or Player.Backpack:FindFirstChild"Lightning Elbow" then
                                class_tier = "Ultra"
                                player_class = "Dragon Sage"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Leg Breaker" or Player.Backpack:FindFirstChild"Spin Kick" or Player.Backpack:FindFirstChild"Rising Dragon") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Akuma"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Akuma"
                            end
                            if Player.Backpack:FindFirstChild"Demon Flip" or Player.Backpack:FindFirstChild"Axe Kick" or Player.Backpack:FindFirstChild"Demon Step" then
                                class_tier = "Ultra"
                                player_class = "Oni"
                            end
                        end

                        if (Player.Backpack:FindFirstChild"Shoulder Bash") and class_tier ~= "Ultra" then
                            if player_class == "Freshie" then
                                class_tier = "Super"
                                player_class = "Warlord"
                            elseif class_tier == "Super" then
                                class_tier = "Hybrid"
                                player_class2 = "Warlord"
                            end
                            if Player.Backpack:FindFirstChild"Wrathful Leap" or Player.Backpack:FindFirstChild"Abyssal Scream" then
                                class_tier = "Ultra"
                                player_class = "Abyss Walker"
                            end
                        end

                        if player_class == "Spy" or player_class == "Assassin" and player_class2 == "None" then
                            if Player.Backpack:FindFirstChild"Song of Lethargy" or Player.Backpack:FindFirstChild"Sweet Soothing" or Player.Backpack:FindFirstChild"Joyous Dance" then
                                class_tier = "Ultra"
                                player_class = "Cadence"
                            end
                        end

                        if player_class2 ~= "None" then
                            table.insert(Extra, "Hybrid-Class("..player_class .. "\\" .. player_class2..")")
                        else
                            table.insert(Extra, player_class)
                        end
                    end

                    if #Character.Artifacts:GetChildren()>0 then
                        local af = Character.Artifacts:GetChildren()[1]
                        if not IsStringEmpty(af) then
                            table.insert(Extra, af.Name);
                        end
                    end
                    if Character:FindFirstChild'DragonHorn'												 				                                                                                                          then table.insert(Extra, 'Kasparan');    end
                    if Character:FindFirstChild'AzaelHorn'												 				                                                                                                          then table.insert(Extra, 'Azael');  	   end
                    if Character:FindFirstChild'Pumpkin Grenade'    or    Player.Backpack:FindFirstChild'Pumpkin Grenade'		                                                                                                  then table.insert(Extra, 'Dullahan');    end
                    if Character:FindFirstChild'Bloodline'		    or    Player.Backpack:FindFirstChild'Bloodline'			                                                                                                      then table.insert(Extra, 'Haseldan');    end
                    if Character:FindFirstChild'Flood'			    or    Player.Backpack:FindFirstChild'Flood'				                                                                                                      then table.insert(Extra, 'Rigan');	   end
                    if Character:FindFirstChild'Galvanize'		    or    Player.Backpack:FindFirstChild'Galvanize'			                                                                                                      then table.insert(Extra, 'Construct');   end
                    if Character:FindFirstChild'Shoulder Throw'	    or    Player.Backpack:FindFirstChild'Shoulder Throw'		                                                                                                  then table.insert(Extra, 'Ashiin');	   end
                    if Character:FindFirstChild'Flock'			    or    Player.Backpack:FindFirstChild'Flock'				                                                                                                      then table.insert(Extra, 'Morvid');	   end
                    if Character:FindFirstChild'Dissolve'		    or    Player.Backpack:FindFirstChild'Dissolve'			                                                                                                      then table.insert(Extra, 'Fischeran');   end
                    if Character:FindFirstChild'Tempest Soul'	    or    Player.Backpack:FindFirstChild'Tempest Soul'		                                                                                                      then table.insert(Extra, 'Vind');	       end
                    if Character:FindFirstChild'Emulate'		    or    Player.Backpack:FindFirstChild'Emulate'				                                                                                                  then table.insert(Extra, 'Navaran');     end
                    if Character:FindFirstChild'World\'s Pulse'     or    Player.Backpack:FindFirstChild'World\'s Pulse'		                                                                                                  then table.insert(Extra, 'Dzin');        end
                    if Character:FindFirstChild'Shift'		 	    or    Player.Backpack:FindFirstChild'Shift'		 	                                                                                                          then table.insert(Extra, 'Madrasian');   end
                    if (Character:FindFirstChild'Repair'            or    Player.Backpack:FindFirstChild'Repair')    and not (Character:FindFirstChild'Decompose'         or Player.Backpack:FindFirstChild'Decompose') 		  then table.insert(Extra, 'Gaian');  	   end
                    if (Character:FindFirstChild'Decompose'         or    Player.Backpack:FindFirstChild'Decompose') and not (Character:FindFirstChild'Repair'            or Player.Backpack:FindFirstChild'Repair') 		 	  then table.insert(Extra, 'Scroom'); 	   end
                    if (Character:FindFirstChild'Decompose'         or    Player.Backpack:FindFirstChild'Decompose') and     (Character:FindFirstChild'Repair'            or Player.Backpack:FindFirstChild'Repair') 		 	  then table.insert(Extra, 'Metascroom');  end
                    if (Character:FindFirstChild'Soul Rip'          or    Player.Backpack:FindFirstChild'Soul Rip')  and not (Character:FindFirstChild'Dark Sigil Helmet' or Player.Backpack:FindFirstChild'Dark Sigil Helmet')   then table.insert(Extra, 'Dinakeri');    end

                    if Character:FindFirstChild'Head' and Character.Head:FindFirstChild'FacialMarking' then
                        local FM = Character.Head:FindFirstChild'FacialMarking';
                        if FM.Texture == 'http://www.roblox.com/asset/?id=4072968006' then
                            table.insert(Extra, 'HEALER');
                        elseif FM.Texture == 'http://www.roblox.com/asset/?id=4072914434' then
                            table.insert(Extra, 'SEER');
                        elseif FM.Texture == 'http://www.roblox.com/asset/?id=4094417635' then
                            table.insert(Extra, 'JESTER');
                        elseif FM.Texture == 'http://www.roblox.com/asset/?id=4072968656' then
                            table.insert(Extra, 'BLADE');
                        end
                    end
                    local tools = Character:FindFirstChildOfClass("Tool")
                    local toolsname = "None"
                    if tools then
                        toolsname = tools.Name
                    end
                    table.insert(Extra2,toolsname)
                end

                if #Extra  > 0 then Name = Name .. '['  .. table.concat(Extra, '-')  .. ']'; end
                if #Extra2 > 0 then Name = Name .. '\n[' .. table.concat(Extra2, '-') .. ']'; end
            end
            return Name;
        end;
    };
    [6473861193] = { -- Deepwoken [East]
		CustomPlayerTag = function(Player)
			local Name = '';
			CharacterName = Player:GetAttribute'CharacterName'; -- could use leaderstats but lazy
		
			if not IsStringEmpty(CharacterName) then
				Name = ('\n[%s]'):format(CharacterName);
				local Character = GetCharacter(Player);
				local Extra = {};
			
				if Character then
					local Blood, Armor, Sanity = Character:FindFirstChild('Blood'), Character:FindFirstChild('Armor'), Character:FindFirstChild("Sanity");
				
					if Blood and Blood.ClassName == 'DoubleConstrainedValue' then
						table.insert(Extra, ('B%d'):format(Blood.Value));
					end
					if Armor and Armor.ClassName == 'DoubleConstrainedValue' then
						table.insert(Extra, ('A%d'):format(math.floor(Armor.Value / 10)));
					end
					if Sanity and Sanity.ClassName == 'DoubleConstrainedValue' then
						table.insert(Extra, ('Sanity %.2f'):format(Sanity.Value));
					end
				end
			
				local BackpackChildren = Player.Backpack:GetChildren()
			
				local mark_void_walker = false
				local has_grasp_of_eylis = false
			
				for index = 1, #BackpackChildren do
					local Oath = BackpackChildren[index]
					if Oath.ClassName == "Folder" then
						if Oath.Name:find('Talent:Oath') then
							local OathName = Oath.Name:gsub('Talent:Oath: ', '')
							table.insert(Extra, OathName);
						elseif Oath.Name:find('Talent:Murmur') then
							local OathName = Oath.Name:gsub('Talent:Murmur: ', '')
							table.insert(Extra, OathName);
						elseif Oath.Name:find('Resonance:') then
							local OathName = Oath.Name:gsub('Resonance:', '')
							table.insert(Extra, OathName);
						elseif Oath.Name:find('Enchant:') then
							local OathName = Oath.Name:gsub('Enchant:', '')
							table.insert(Extra, OathName);
						elseif Oath.Name:find("Talent:Voidwalker Contract") then
							mark_void_walker = true
						end
					end
				end
			
				if mark_void_walker then
					table.insert(Extra, "VoidWalker");
				end
			
				if #Extra > 0 then Name = Name .. ' [' .. table.concat(Extra, '-') .. ']'; end
			end
		
			return Name;
		end;
	};