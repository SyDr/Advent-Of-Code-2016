local lpeg = require'lpeg'
--local pp = require'pretty'

local direction = lpeg.S'RL' ^ 1
local number = lpeg.R'09' ^ 1
local entry =  lpeg.C(direction * number)
local pattern = lpeg.Ct((entry * lpeg.P", " ^ -1) ^ 1)

local file_data = io.open("1.txt"):read("*a")
local data = lpeg.match(pattern, file_data)

local direction_ex = lpeg.C(direction) / function(s) if s == 'R' then return 1 else return -1 end end
local number_ex = lpeg.C(number) / tonumber
local pattern_ex = direction_ex * number_ex

local distX, distY = 0, 0
local curX, curY = 0, 1 

local already_visited = {}
already_visited["0x0"] = true

local done = false

for i, item in ipairs(data) do
  local dir, num = lpeg.match(pattern_ex, item)
  curX, curY = curY * dir, curX * dir * -1
  
  for i = 1, num do
    distX = distX + curX
    distY = distY + curY
  
    if already_visited[tostring(distX) .. "x" .. tostring(distY)] then
      done = true
      break
    else
      already_visited[tostring(distX) .. "x" .. tostring(distY)] = true
    end
  end
  
  if done then break end
end

print(math.abs(distX) + math.abs(distY))
