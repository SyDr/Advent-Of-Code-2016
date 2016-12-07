local lpeg = require'lpeg'
--local pp = require'pretty'

local supernet = lpeg.R'az' ^ 1
local hypernet = lpeg.P("[") * supernet * lpeg.P("]")
local pattern = lpeg.Ct((lpeg.C(supernet) + lpeg.C(hypernet)) ^ 1)

local function isABBA(s)
  local result = false
  for i = 1, string.len(s) - 3 do
    local a1, b1, b2, a2 = string.sub(s, i, i), string.sub(s, i + 1, i + 1), string.sub(s, i + 2, i + 2), string.sub(s, i + 3, i + 3)
    if a1 == a2 and b1 == b2 and a1 ~= b2 then result = true end
    if result then break end
  end
    
  return result
end

local function genABA(s)
  local function gen(s)
    for i = 1, string.len(s) - 2 do
      local a1, b1, a2 = string.sub(s, i, i), string.sub(s, i + 1, i + 1), string.sub(s, i + 2, i + 2)
      if a1 == a2 and a1 ~= b1 then coroutine.yield(a1 .. b1 .. a2) end
    end
  end
  
  local co = coroutine.create(function () gen(s) end)
  
  return function ()   -- iterator
    local code, res = coroutine.resume(co)
    return res
  end
end

local function hasBAB(s, aba)
  local bab = string.sub(aba, 2, 2) .. string.sub(aba, 1, 1) .. string.sub(aba, 2, 2)
  
  return string.find(s, bab)
end

local total1 = 0
local total2 = 0

for line in io.lines("7.txt") do
  local data = lpeg.match(pattern, line)
  local supportTLS = false
  
  for i, item in ipairs(data) do
    local abba = isABBA(item)
    if string.sub(item, 1, 1) == "[" and abba then
      supportTLS = false
      break
    elseif abba then
      supportTLS = true
    end
  end
  
  local supportSSL = false
  for i, item in ipairs(data) do
    if string.sub(item, 1, 1) ~= "[" then
      local gen = genABA(item)
      for x in gen do
        for k, otherItem in ipairs(data) do
          if string.sub(otherItem, 1, 1) == "[" and hasBAB(otherItem, x) then
            supportSSL = true
            break
          end
        end
      end
      if supportSSL then break end
    end
  end
    
  if supportTLS then total1 = total1 + 1 end
  if supportSSL then total2 = total2 + 1 end
end

print(total1)
print(total2)
