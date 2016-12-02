local lpeg = require'lpeg'
local pp = require'pretty'

local function to_v(s)
  if s == "L" then
    return { -1, 0 }
  elseif s == "U" then
    return { 0, -1 }
  elseif s == "R" then
    return { 1, 0 }
  else
    return { 0, 1 }
  end
end

local direction = lpeg.C(lpeg.S'LURD') / to_v
local pattern = lpeg.Ct(direction ^ 1)

local curX, curY = 1, 3

local keypad = {}
keypad["3x1"] = "1"
keypad["2x2"] = "2"
keypad["3x2"] = "3"
keypad["4x2"] = "4"
keypad["1x3"] = "5"
keypad["2x3"] = "6"
keypad["3x3"] = "7"
keypad["4x3"] = "8"
keypad["5x3"] = "9"
keypad["2x4"] = "A"
keypad["3x4"] = "B"
keypad["4x4"] = "C"
keypad["3x5"] = "D"

for line in io.lines("2.txt") do
  local data = lpeg.match(pattern, line)
  for i, item in ipairs(data) do
    local tmpX, tmpY = curX + item[1], curY + item[2]
    if keypad[tostring(tmpX) .. "x" .. tostring(tmpY)] then
      curX, curY = tmpX, tmpY
    end
  end
  io.write(keypad[tostring(curX) .. "x" .. tostring(curY)])
end

print()
