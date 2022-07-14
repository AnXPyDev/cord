half_pi = math.pi * 0.5

return {
	linear: ->
		return (x) -> x

	ease_in: (exponent) ->
		return (x) -> math.pow(x, exponent)

	ease_out: (exponent) ->
		return (x) -> 1 - math.pow(1 - x, exponent)

	ease_both: (exponent) ->
		return (x) ->
			if x < 0.5
				return math.pow(x*2, exponent) * 0.5
			return 1 - math.pow((1-x) * 2, exponent) * 0.5
	
	circle_in: ->
		return (x) -> 1 - math.sqrt(1 - x*x)

	circle_out: ->
		return (x) -> math.sqrt(-x*x+2*x)

	circle_both: ->
		return (x) ->
			if x < 0.5
				return (1 - math.sqrt(1 - 4*x*x)) * 0.5
			return (1 + math.sqrt(1 - 4*x*x + 8*x - 4)) * 0.5

	sin_in: ->
		return (x) -> 1 - math.cos(x * half_pi)

	sin_out: ->
		return (x) -> math.sin(x * half_pi)

	sin_both: ->
		return (x) -> (math.sin((x - 0.5) * math.pi) + 1) * 0.5

}
