local lpeg = require'lpeg'
local pp = require'pretty'
local md5 = require'md5'

local input = 'qljzarfv'

local answer = input
local queue = { [input] = {1, 1} }
local dir_list = { "U", "D", "L", "R" }
local directions = { U = { 0, -1}, D = { 0, 1 }, L = { -1, 0 }, R = { 1, 0 } }

local function get_moves(key)
  local hash = md5.sumhexa(key)
  local r = {}
  
  for i, v in ipairs(dir_list) do
    if tonumber(string.sub(hash, i, i), 16) > 10 then r[#r + 1] = v end
  end
  
  return r
end

local function is_valid_pos(x, y)
  return x > 0 and x < 5 and y > 0 and y < 5
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
        if is_valid_pos(new_pos[1], new_pos[2]) then      
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
