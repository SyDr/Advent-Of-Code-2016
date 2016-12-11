--local lpeg = require'lpeg'
local pp = require'pretty'

local size = 14
--local mask = "SsPpTtRrCcEeDdSsPpTtRrCcEeDdSsPpTtRrCcEeDdSsPpTtRrCcEeDd_"
local order = { "S", "P", "T", "R", "C", "E", "D" }
local pos_map = { S = 1, P = 3, T = 5, R = 7, C = 9, E = 11, D = 13 }

local target = "                                          SsPpTtRrCcEeDd4"
local input  = "SsPp      EeDd    T RrCc         t                      1"

local function replace(s, i, char)
  return string.sub(s, 1, i - 1) .. char .. string.sub(s, i + 1)
end

local function find(t, v)
  for i, item in ipairs(t) do
    if item == v then
      return i
    end
  end
end

local function transform(key)
  local current = 1
  local order = order
  
  local t = {}
  for i = 1, string.len(key) do
      t[i] = string.sub(key, i, i)
  end

  for i = 1, #t - 1, 2 do
    if current > #order then break end
    
    local sym = t[i]
    if sym ~= " " and sym ~= order[current] then
      local pos1b, pos1s = find(t, order[current]), find(t, string.lower(order[current]))
      local pos2b, pos2s = i, find(t, string.lower(sym))
      
      local n_pos1b, n_pos1s = math.floor((pos2b - 1) / size) * size + pos_map[order[current]], math.floor((pos2s - 1) / size) * size + pos_map[order[current]] + 1
      local n_pos2b, n_pos2s = math.floor((pos1b - 1) / size) * size + pos_map[sym], math.floor((pos1s - 1) / size) * size + pos_map[sym] + 1

      t[pos1b] = ' '
      t[pos1s] = ' '
      t[pos2b] = ' '
      t[pos2s] = ' '
      
      t[n_pos1b] = order[current]
      t[n_pos1s] = string.lower(order[current])
      t[n_pos2b] = sym
      t[n_pos2s] = string.lower(sym)
           
      current = current + 1
    elseif sym == order[current] then
      current = current + 1
    end
  end
  
  return table.concat(t)
end

local function is_valid(s)
  for i = 1, 4 do
    local ss = string.sub(s, (i - 1) * size + 1, i * size)
    local any_generator = false
    for j = 1, string.len(ss), 2 do
      if string.sub(ss, j, j) ~= " " then any_generator = true break end
    end

    for j = 1, string.len(ss), 2 do
      if string.sub(ss, j + 1, j + 1) ~= " " and string.sub(ss, j, j) == " " and any_generator then return false end
    end
  end
  
  return true
end

local data = { [transform(input)] = 0 }
local queue = { [transform(input)] = true }

while not data[target] do
  local keys = {}
  for key, _ in pairs(queue) do
    keys[#keys + 1] = key
  end
  
  io.write(#keys)
  
  for n, x in ipairs(keys) do
    local key = string.sub(keys[n], 1, size * 4)
    local num = data[x]
    local pos = tonumber(string.sub(keys[n], size * 4 + 1, size * 4 + 1))
    
    if n % 100 == 0 then io.write(".") end
    
    queue[keys[n]] = nil
    
    for i = 1, size do
      for j = i, size do
        local i_index = (pos - 1) * size + i
        local j_index = (pos - 1) * size + j
        
        local ikey = string.sub(key, i_index, i_index)
        local jkey = string.sub(key, j_index, j_index)
        
        if ikey ~= " " or jkey ~= " " then
          local skey = replace(replace(key, i_index, " "), j_index, " ")
          if pos > 1 then
            local rkey_p = skey .. tostring(pos - 1)
            if ikey ~= " " then rkey_p = replace(rkey_p, (pos - 2) * size + i, ikey) end
            if jkey ~= " " then rkey_p = replace(rkey_p, (pos - 2) * size + j, jkey) end
            rkey_p = transform(rkey_p)
            
            if not data[rkey_p] and is_valid(rkey_p) then
              data[rkey_p] = num + 1
              queue[rkey_p] = true
            end
          end
          
          if pos < 4 then
            local rkey_m = skey .. tostring(pos + 1)
            if ikey ~= " " then rkey_m = replace(rkey_m, pos * size + i, ikey) end
            if jkey ~= " " then rkey_m = replace(rkey_m, pos * size + j, jkey) end
            rkey_m = transform(rkey_m)
            
            if not data[rkey_m] and is_valid(rkey_m) then
              data[rkey_m] = num + 1
              queue[rkey_m] = true
            end
          end
        end
      end
    end  
  end
  print()
end

print(pp(data[target]))
