local md5 = require'md5'

local prefix = 'qzyelonm'

local function find_triplet(s)
  for i = 1, string.len(s) - 2 do
    if string.sub(s, i, i) == string.sub(s, i + 1, i + 1) and string.sub(s, i + 2, i + 2) == string.sub(s, i + 1, i + 1) then
      return string.sub(s, i, i)
    end
  end
end

local function is_key(s, c)
  return string.find(s, string.rep(c, 5))
end

local function hash1(s)
  return md5.sumhexa(s)
end

local function hash2(s)
  for i = 1, 2017 do
    s = md5.sumhexa(s)
  end
  
  return s
end

local function solve(hash)
  local data = {}
  local total = 0
  local current = 0
  local last = 0
  
  while total < 64 do
    if not data[current] then data[current] = hash(string.format(prefix .. "%d", current)) end
   
    local c = find_triplet(data[current])
    
    if c then
      for i = 1, 1000 do
        if not data[current + i] then data[current + i] = hash(string.format(prefix .. "%d", current + i)) end
        
        if is_key(data[current + i], c) then
          total = total + 1
          last = current
          break
        end
      end
    end
    
    current = current + 1
  end
  
  return last
end

print("1:", solve(hash1))
print("2:", solve(hash2))
