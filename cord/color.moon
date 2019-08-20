hsl_to_rgb = (hsla_array) ->
   h, s, l, a = unpack hsla_array
   local m1, m2
   if l<=0.5 then 
      m2 = l*(s+1)
   else 
      m2 = l+s-l*s
   m1 = l*2-m2

   _h2rgb = (m1, m2, h) ->
      if h<0 then h = h+1
      if h>1 then h = h-1
      if h*6<1
         return m1+(m2-m1)*h*6
      elseif h*2<1
         return m2 
      elseif h*3<2
         return m1+(m2-m1)*(2/3-h)*6
      else
         return m1

   return {_h2rgb(m1, m2, h+1/3), _h2rgb(m1, m2, h), _h2rgb(m1, m2, h-1/3), a or 1}

rgb_to_hsl = (rgba_array) ->
   r, g, b, a = unpack rgba_array
   min = math.min(r, g, b)
   max = math.max(r, g, b)
   delta = max - min

   h, s, l = 0, 0, ((min+max)/2)

   if l > 0 and l < 0.5 then s = delta/(max+min)
   if l >= 0.5 and l < 1 then s = delta/(2-max-min)

   if delta > 0
      if max == r and max ~= g then h = h + (g-b)/delta
      if max == g and max ~= b then h = h + 2 + (b-r)/delta
      if max == b and max ~= r then h = h + 4 + (r-g)/delta
      h = h / 6;

   if h < 0 then h = h + 1
   if h > 1 then h = h - 1

   return {h, s, l, a or 1}

hex_string_to_array = (hex_string) ->
  result = {}
  if hex_string\sub(1,1) == "#"
    hex_string = hex_string\sub(2)
  for i = 1, math.floor(hex_string\len! / 2)
    table.insert(result, hex_string\sub(i * 2 - 1, i * 2))
  return result

array_to_hex_string = (array) ->
  result = "#"
  for val in *array
    result = result .. string.format("%02x", math.floor(v*255 + 0.5))

