split = require("gears.string").split

character = (str1, str2, compare_lowercase) ->
	str1 = compare_lowercase and str1\lower! or str1
	str2 = compare_lowercase and str2\lower! or str2

	matches = {}
	last_found = 0

	for char_index = 1, str1\len!
		search_result = str2\find(str1\sub(char_index, char_index))
		if search_result
			matches[char_index] = search_result - last_found
			last_found = search_result

	if #matches == 0
		return 0

	average_distance = 0

	for key, match in ipairs(matches)
		average_distance += match

	average_distance /= #matches

	return (#matches / str1\len!) * (1 / average_distance)

word = (str1, str2, compare_lowercase) ->
	str1 = compare_lowercase and str1\lower! or str1
	str2 = compare_lowercase and str2\lower! or str2

	first_found, last_found = 0, 0

	word_list = split(str1, " ")

	for key, word in ipairs word_list
		first_found, last_found = str2\find(word, last_found + 1)
		if not first_found
			return false

	return true
		
return {
	character: character
	word: word
}
