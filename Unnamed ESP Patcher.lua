printconsole("[Patcher][Info]Fetching UnnamedESP Source Code")
local source_code = game:HttpGet('https://raw.githubusercontent.com/ic3w0lf22/Unnamed-ESP/master/UnnamedESP.lua')
printconsole("[Patcher][Info]Find local Variable 'Modules' End Array UnnamedESP Source Code")
local source_start_injection_code, source_end_injection_code = source_code:find('};\n\nif')
local newmodules = game:HttpGet('https://github.com/plytalent/Roblox-Hacks/raw/main/UnnamedESP%20Patch%20For%20Patcher/NewModule.lua')
local replacemodules = game:HttpGet('https://github.com/plytalent/Roblox-Hacks/raw/main/UnnamedESP%20Patch%20For%20Patcher/ReplaceModule.lua')
printconsole("[Patcher][Info]Executing Modified UnnamedESP Source Code")
local newsourcecode = source_code:sub(1,source_start_injection_code-1)..";\n--[[Start of New Modules]]--\n" .. newmodules .. "\n--[[End of New Modules]]--\n};\n\n--[[Start of Replace Modules]]--\n" .. replacemodules..  "\n--[[End of Replace Modules]]--\n".. source_code:sub(source_end_injection_code-1)
local s,err = pcall(loadstring(newsourcecode))
if not s then
  printconsole("[UnnamedESP][ERROR]"..err)
end
