local split = require("gears.string").split
local character
character = function(str1, str2, compare_lowercase)
  str1 = compare_lowercase and str1:lower() or str1
  str2 = compare_lowercase and str2:lower() or str2
  local matches = { }
  local last_found = 0
  for char_index = 1, str1:len() do
    local search_result = str2:find(str1:sub(char_index, char_index))
    if search_result then
      matches[char_index] = search_result - last_found
      last_found = search_result
    end
  end
  if #matches == 0 then
    return 0
  end
  local average_distance = 0
  for key, match in ipairs(matches) do
    average_distance = average_distance + match
  end
  average_distance = average_distance / #matches
  return (#matches / str1:len()) * (1 / average_distance)
end
local word
word = function(str1, str2, compare_lowercase)
  str1 = compare_lowercase and str1:lower() or str1
  str2 = compare_lowercase and str2:lower() or str2
  local first_found, last_found = 0, 0
  local word_list = split(str1, " ")
  for key, word in ipairs(word_list) do
    first_found, last_found = str2:find(word, last_found + 1)
    if not first_found then
      return false
    end
  end
  return true
end
return {
  character = character,
  word = word
}
