local md5 = require 'md5'
local pp = require 'pretty'

local function startswith(str, start)
   return string.sub(str, 1, string.len(start)) == start
end

local function replace(str, pos, new)
    return str:sub(1, pos - 1) .. new .. str:sub(pos + 1)
end

local result = '________'

for i = 0, 1000000000 do
  local hash = md5.sumhexa(string.format("abbhdwsy%d", i))
  if startswith(hash, "00000") then
    local pos = string.sub(hash, 6, 6)
    local item = string.sub(hash, 7, 7)
    if string.byte(pos) >= string.byte('0') and string.byte(pos) <= string.byte('7') and string.sub(result, pos + 1, pos + 1) == '_' then
      result = replace(result, pos + 1, item)
      print(result)
      if not string.find(result, '_') then break end
    end
  end
end