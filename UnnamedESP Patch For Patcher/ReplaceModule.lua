	[6032399813] = { -- Deepwoken [Etrean]
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
						elseif Oath.Name:find("Talent:Lightweight") then
							table.insert(Extra, "LW");
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
    [5735553160] = { -- Deepwoken [Depths]
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
						elseif Oath.Name:find("Talent:Lightweight") then
							table.insert(Extra, "LW");
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
