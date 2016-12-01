-- Table pretty print (but can be used on anything, including recursive tables)
local function pretty_print(to_print, name, tab, indent, printed_tables)
  tab = tab or 2
  indent = indent or 0
  printed_tables = printed_tables or {}
  
  local result = {}
  
  if type(to_print) ~= 'table' or printed_tables[to_print] then
    if name then
      return string.format('%s[%s] => [%s]', string.rep(" ", indent), name, type(to_print) == 'string' and '"' .. to_print .. '"' or tostring(to_print))
    else
      return string.format('%s[%s]', string.rep(" ", indent), to_print)
    end
  else
    printed_tables[to_print] = true
    result[#result + 1] = string.format('%s[%s] = %s', string.rep(" ", indent), name or to_print, "{") 
    for key, value in pairs(to_print) do
      result[#result + 1] = pretty_print(value, key, tab, indent + tab, printed_tables)
    end
    result[#result + 1] = string.rep(" ", indent) .. "}"
  end
  
  return result
end

local function rconcat(l)
  if type(l) ~= "table" then return l end
  local res = {}
  for i = 1, #l do
    res[i] = rconcat(l[i])
  end
  
  return table.concat(res, '\n')
end

return function(to_print) return rconcat(pretty_print(to_print)) end