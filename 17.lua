local lpeg = require'lpeg'
local pp = require'pretty'
local md5 = require'md5'

local input = 'qljzarfv'

local answer = input
local queue = { [input] = {1, 1} }
local directions = { U = { 0, -1}, D = { 0, 1 }, L = { -1, 0 }, R = { 1, 0 } }

local function get_moves(key)
  local hash = md5.sumhexa(key)
  local r = {}
  
  if string.byte(string.sub(hash, 1, 1)) > string.byte('a') then r[#r + 1] = 'U' end
  if string.byte(string.sub(hash, 2, 2)) > string.byte('a') then r[#r + 1] = 'D' end
  if string.byte(string.sub(hash, 3, 3)) > string.byte('a') then r[#r + 1] = 'L' end
  if string.byte(string.sub(hash, 4, 4)) > string.byte('a') then r[#r + 1] = 'R' end
  
  return r
end

local function solve()
  local result
  local max = 0
  
  while true do
    local keys = {}
    for key, value in pairs(queue) do
      keys[#keys + 1] = { key, value }
    end
    queue = {}
    
    if #keys == 0 then break end
    
    for _, key in ipairs(keys) do
      for _, move in pairs(get_moves(key[1])) do
        local new_pos = { key[2][1] + directions[move][1], key[2][2] + directions[move][2] }
        if new_pos[1] > 0 and new_pos[1] < 5 and new_pos[2] > 0 and new_pos[2] < 5 then      
          local new_key = key[1] .. move
          if new_pos[1] == 4 and new_pos[2] == 4 then
            if not result then result = new_key end
            if string.len(new_key) > max then max = string.len(new_key) end
          else
            queue[new_key] = new_pos
          end
        end
      end
    end
  end
  
  return { result, max }
end

local result = solve()
print("1:", string.sub(result[1], string.len(input) + 1))
print("2:", result[2] - string.len(input))
