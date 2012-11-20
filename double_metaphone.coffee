TEXT_TOOLS = {} unless TEXT_TOOLS?

TEXT_TOOLS.doubleMetaphone = ( str )->
  primary = []
  secondary = []
  current = 0

  max_iter = 20
  iter = 0

  original = str + "     "
  original = original.toUpperCase()
  length = str.length
  last = str.length - 1

  if(original.substr(0,2).match(/^GN|KN|PN|WR|PS$/ ))
    current += 1
  if('X' == original[0])
    primary.push('S')
    secondary.push('S')
    current += 1
  while( primary.length < 4 || secondary.length < 4 )
    if iter < max_iter
      ++iter
    else
      # console.log "MAX ITERATIONS for '#{original}'"
      break
    break if current > str.length
    [a,b,c] = TEXT_TOOLS._double_metaphone_lookup(original, current, length, last)
    # console.log " returns", a, b, c
    primary.push( a ) if a?
    secondary.push( b ) if b?
    current += c if c?
  primary = primary.join( "" ).substr( 0, 4 )
  secondary = secondary.join( "" ).substr( 0, 4 )
  return [primary, if primary == secondary then null else secondary]

TEXT_TOOLS._is_vowel = ( str )->
  str.match( /^A|E|I|O|U|Y$/ )

TEXT_TOOLS._is_slavo_germanic = ( str )->
  str.match( /W|K|CZ|WITZ/g )

TEXT_TOOLS._double_metaphone_lookup = ( str, pos, length, last )->
  # console.log "_double_metaphone_lookup '#{str}'", pos, length, last
  if TEXT_TOOLS._is_vowel( str.substr(pos, 1) )
    # console.log "/^A|E|I|O|U|Y$/"
    if pos == 0
      return ['A', 'A', 1]
    else
      return [null, null, 1]
  else
    # console.log "switch #{str.substr(pos, 1)}"
    switch str.substr(pos, 1)
      when 'B'
        return ['P', 'P', (if str.substr( pos + 1, 1) == 'B' then 2 else 1)]
      when 'Ç'
        return ['S', 'S', 1]
      when 'C'
        if pos > 1 && !TEXT_TOOLS._is_vowel( str.substr( pos - 2, 1 )) && 'ACH' == str.substr( pos - 1, 3 ) && str.substr( pos + 2, 1 ) != 'I' && ( str.substr( pos + 2, 1 ) != 'E' || str.substr( pos - 2, 6 ).match( /^(B|M)ACHER$/ ) )
          return ['K', 'K', 2]
        else if 0 == pos && 'CAESAR' == str.substr( pos, 6 )
          return ['S', 'S', 2]
        else if 'CHIA' == str.substr( pos, 4 )
          return ['K', 'K', 2]
        else if 'CH' == str.substr( pos, 2 )
          if pos > 0 && 'CHAE' == str.substr( pos, 4 )
            return ['K', 'X', 2]
          else if pos == 0 && ( ['HARAC', 'HARIS'].indexOf(str.substr( pos + 1, 5 )) >= 0 ||
              ['HOR', 'HYM', 'HIA', 'HEM'].indexOf(str.substr( pos + 1, 3 )) >= 0) && str.substr( 0, 5 ) != 'CHORE'
            return ['K', 'K', 2]
          else if ['VAN ','VON '].indexOf(str.substr( 0, 4 )) >= 0 || 'SCH' == str.substr( 0, 3 ) ||
                ['ORCHES','ARCHIT','ORCHID'].indexOf(str.substr( pos - 2, 6 )) >= 0 ||
                ['T','S'].indexOf(str.substr( pos + 2, 1 )) >= 0 || (
                  ((0 == pos) || ['A','O','U','E'].indexOf(str.substr( pos - 1, 1 )) >= 0) &&
                  ['L','R','N','M','B','H','F','V','W',' '].indexOf(str.substr( pos + 2, 1 )) >= 0)
            return ['K', 'K', 2]
          else if pos > 0
            return [(if 'MC' == str.substr( 0, 2 ) then 'K' else 'X'), 'K', 2]
          else
            return ['X', 'X', 2]
        else if 'CZ' == str.substr( pos, 2 ) && 'WICZ' != str.substr( pos - 2, 4 )
          return ['S', 'X', 2]
        else if 'CIA' == str.substr( pos + 1, 3 )
          return ['X', 'X', 3]
        else if 'CC' == str.substr( pos, 2 ) && !(1 == pos && 'M' == str.substr( 0, 1 ))
          if str.substr( pos + 2, 1 ).match(/^I|E|H$/) && 'HU' != str.substr( pos + 2, 2 )
            if (pos == 1 && 'A' == str.substr( pos - 1, 1 )) || str.substr( pos - 1, 5 ).match(/^UCCE(E|S)$/)
              return ['KS', 'KS', 3]
            else
              return ['X', 'X', 3]
          else
            return ['K', 'K', 2]
        else if str.substr( pos, 2 ).match( /^C(K|G|Q)$/ )
          return ['K', 'K', 2]
        else if str.substr( pos, 2 ).match( /^C(I|E|Y)$/ )
          return ['S', (if str.substr( pos, 3 ).match( /^CI(O|E|A)$/ ) then 'X' else 'S'), 2]
        else
          if str.substr( pos + 1, 2 ).match( /^ (C|Q|G)$/ )
            return ['K', 'K', 3]
          else
            return ['K', 'K', (if str.substr( pos + 1, 1 ).match( /^C|K|Q$/ ) && (['CE','CI'].indexOf(str.substr( pos + 1, 2 )) < 0) then 2 else 1)]
      when 'D'
        if 'DG' == str.substr( pos, 2 )
          if str.substr( pos + 2, 1 ).match(/^I|E|Y$/)
            return ['J', 'J', 3]
          else
            return ['TK', 'TK', 2]
        else
          return ['T', 'T', (if str.substr( pos, 2 ).match(/^D(T|D)$/) then 2 else 1)]
      when 'F'
        return ['F', 'F', (if 'F' == str.substr( pos + 1, 1 ) then 2 else 1)]
      when 'G'
        if 'H' == str.substr( pos + 1, 1)
          if pos > 0 && !TEXT_TOOLS._is_vowel(str.substr( pos - 1, 1 ))
            return ['K', 'K', 2]
          else if 0 == pos
            if 'I' == str.substr( pos + 2, 1 )
              return ['J', 'J', 2]
            else
              return ['K', 'K', 2]
          else if (pos > 1 && str.substr( pos - 2, 1 ).match( /^B|H|D$/ )) ||
                (pos > 2 && str.substr( pos - 3, 1 ).match( /^B|H|D$/ )) ||
                (pos > 3 && str.substr( pos - 4, 1 ).match( /^B|H$/ ))
            return [null, null, 2]
          else
            if (pos > 2 && 'U' == str.substr( pos - 1, 1 ) && str.substr( pos - 3, 1 ).match( /^C|G|L|R|T$/ ))
              return ['F', 'F', 2]
            else if pos > 0 && 'I' != str.substr( pos - 1, 1 )
              return ['K', 'K', 2]
            else
              return [null, null, 2]
        else if 'N' == str.substr( pos + 1, 1 )
          if 1 == pos && TEXT_TOOLS._is_vowel(str.substr( 0, 1 )) && !TEXT_TOOLS._is_slavo_germanic(str)
            return ['KN', 'N', 2]
          else
            if 'EY' != str.substr( pos + 2, 2 ) && 'Y' != str.substr( pos + 1, 1 ) && !TEXT_TOOLS._is_slavo_germanic(str)
              return ['N', 'KN', 2]
            else
              return ['KN', 'KN', 2]
        else if 'LI' == str.substr( pos + 1, 2 ) && !TEXT_TOOLS._is_slavo_germanic(str)
          return ['KL', 'L', 2]
        else if 0 == pos && ('Y' == str.substr( pos + 1, 1 ) || str.substr( pos + 1, 2 ).match( /^(E(S|P|B|L|Y|I|R)|I(B|L|N|E))$/ ))
          return ['K', 'J', 2]
        else if (('ER' == str.substr( pos + 1, 2 ) || 'Y' == str.substr( pos + 1, 1 )) &&
               !str.substr( 0, 6 ).match( /^(D|R|M)ANGER$/ ) &&
               !str.substr( pos - 1, 1 ).match( /^E|I$/ ) &&
              !str.substr( pos - 1, 3 ).match( /^(R|O)GY$/ ))
          return ['K', 'J', 2]
        else if str.substr( pos + 1, 1 ).match( /^E|I|Y$/ ) || str.substr( pos - 1, 4 ).match( /^(A|O)GGI$/ )
          if (str.substr( 0, 4 ).match( /^V(A|O)N $/ ) || 'SCH' == str.substr( 0, 3 )) || 'ET' == str.substr( pos + 1, 2 )
            return ['K', 'K', 2]
          else
            if 'IER ' == str.substr( pos + 1, 4 )
              return ['J', 'J', 2]
            else
              return ['J', 'K', 2]
        else if 'G' == str.substr( pos + 1, 1 )
          return ['K', 'K', 2]
        else
          return ['K', 'K', 1]
      when 'H'
        if (0 == pos || TEXT_TOOLS._is_vowel(str.substr( pos - 1, 1 ))) && TEXT_TOOLS._is_vowel(str.substr( pos + 1, 1))
          return ['H', 'H', 2]
        else
          return [null, null, 1]
      when 'J'
        if 'JOSE' == str.substr( pos, 4 ) || 'SAN ' == str.substr( 0, 4 )
          if (0 == pos && ' ' == str.substr( pos + 4, 1 )) || 'SAN ' == str.substr( 0, 4 )
            return ['H', 'H', 1]
          else
            return ['J', 'H', 1]
        else
          current = (if 'J' == str.substr( pos + 1, 1 ) then 2 else 1)

          if 0 == pos && 'JOSE' != str.substr( pos, 4 )
            return ['J', 'A', current]
          else
            if TEXT_TOOLS._is_vowel(str.substr( pos - 1, 1 )) && !TEXT_TOOLS._is_slavo_germanic(str) && str.substr( pos + 1, 1 ).match( /^A|O$/ )
              return ['J', 'H', current]
            else
              if last == pos
                return ['J', null, current]
              else
                if !str.substr( pos + 1, 1 ).match( /^L|T|K|S|N|M|B|Z$/ ) && !str.substr( pos - 1, 1 ).match( /^S|K|L$/ )
                  return ['J', 'J', current]
                else
                  return [null, null, current]
      when 'K'
        return ['K', 'K', (if str.substr( pos + 1, 1 ) == 'K' then 2 else 1)]
      when 'L'
        if 'L' == str.substr( pos + 1, 1 )
          if (((length - 3) == pos && str.substr( pos - 1, 4 ).match( /^(ILL(O|A)|ALLE)$/ )) ||
              (( str.substr( last - 1, 2 ).match( /^(A|O)S$/ ) || str.substr( last, 1 ).match( /^A|O$/ ) ) && 'ALLE' == str.substr( pos - 1, 4 )))
            return ['L', null, 2]
          else
            return ['L', 'L', 2]
        else
          return ['L', 'L', 1]
      when 'M'
        if ('UMB' == str.substr( pos - 1, 3 ) &&
            ((last - 1) == pos || 'ER' == str.substr( pos + 2, 2 ))) || 'M' == str.substr( pos + 1, 1 )
          return ['M', 'M', 2]
        else
          return ['M', 'M', 1]
      when 'N'
        return ['N', 'N', (if 'N' == str.substr( pos + 1, 1 ) then 2 else 1)]
      when 'Ñ'
        return ['N', 'N', 1]
      when 'P'
        if 'H' == str.substr( pos + 1, 1 )
          return ['F', 'F', 2]
        else
          return ['P', 'P', (if str.substr( pos + 1, 1 ).match( /^P|B$/ ) then 2 else 1)]
      when 'Q'
        return ['K', 'K', (if 'Q' == str.substr( pos + 1, 1 ) then 2 else 1)]
      when 'R'
        current = (if 'R' == str.substr( pos + 1, 1 ) then 2 else 1)
        if last == pos && !TEXT_TOOLS._is_slavo_germanic(str) && 'IE' == str.substr( pos - 2, 2 ) && !str.substr( pos - 4, 2 ).match( /^M(E|A)$/ )
          return [null, 'R', current]
        else
          return ['R', 'R', current]
      when 'S'
        if str.substr( pos - 1, 3 ).match( /^(I|Y)SL$/ )
          return [null, null, 1]
        else if 0 == pos && 'SUGAR' == str.substr( pos, 5 )
          return ['X', 'S', 1]
        else if 'SH' == str.substr( pos, 2 )
          if str.substr( pos + 1, 4 ).match( /^H(EIM|OEK|OLM|OLZ)$/ )
            return ['S', 'S', 2]
          else
            return ['X', 'X', 2]
        else if str.substr( pos, 3 ).match( /^SI(O|A)$/ ) || 'SIAN' == str.substr( pos, 4 )
          return ['S', (if TEXT_TOOLS._is_slavo_germanic(str) then 'S' else 'X'), 3]
        else if (0 == pos && str.substr( pos + 1, 1 ).match( /^M|N|L|W$/ )) || 'Z' == str.substr( pos + 1, 1 )
          return ['S', 'X', (if 'Z' == str.substr( pos + 1, 1 ) then 2 else 1)]
        else if 'SC' == str.substr( pos, 2 )
          if 'H' == str.substr( pos + 2, 1 )
            if str.substr( pos + 3, 2 ).match( /^OO|ER|EN|UY|ED|EM$/ )
              return [(if str.substr( pos + 3, 2 ).match( /^E(R|N)$/ ) then 'X' else 'SK'), 'SK', 3]
            else
              return ['X', (if (0 == pos && !TEXT_TOOLS._is_vowel(str.substr( 3, 1 )) && ('W' != str.substr( pos + 3, 1 ))) then 'S' else 'X'), 3]
          else if str.substr( pos + 2, 1 ).match( /^I|E|Y$/ )
            return ['S', 'S', 3]
          else
            return ['SK', 'SK', 3]
        else
          return [(if last == pos && str.substr( pos - 2, 2 ).match( /^(A|O)I$/ ) then null else 'S'), 'S', (if str.substr( pos + 1, 1).match( /^S|Z$/ ) then 2 else 1)]
      when 'T'
        if 'TION' == str.substr( pos, 4 )
          return ['X', 'X', 3]
        else if str.substr( pos, 3 ).match( /^T(IA|CH)$/ )
          return ['X', 'X', 3]
        else if 'TH' == str.substr( pos, 2 ) || 'TTH' == str.substr( pos, 3 )
          if str.substr( pos + 2, 2 ).match( /^(O|A)M$/ ) || str.substr( 0, 4 ).match( /^V(A|O)N $/ ) || 'SCH' == str.substr( 0, 3 )
            return ['T', 'T', 2]
          else
            return [0, 'T', 2]
        else
          return ['T', 'T', ( if str.substr( pos + 1, 1 ).match( /^T|D$/ ) then 2 else 1)]
      when 'V'
        return ['F', 'F', (if 'V' == str.substr( pos + 1, 1 ) then 2 else 1)]
      when 'W'
        if 'WR' == str.substr( pos, 2 )
          return ['R', 'R', 2]
        [pri, sec] = [null, null]
        if 0 == pos && (TEXT_TOOLS._is_vowel(str.substr( pos + 1, 1 )) || 'WH' == str.substr( pos, 2 ))
          pri = 'A'
          sec = if TEXT_TOOLS._is_vowel(str.substr( pos + 1, 1 )) then 'F' else 'A'
        if (last == pos && TEXT_TOOLS._is_vowel(str.substr( pos - 1, 1 ))) || 'SCH' == str.substr( 0, 3 ) || str.substr( pos - 1, 5 ).match( /^EWSKI|EWSKY|OWSKI|OWSKY$/ )
          return [pri, (if sec? then "#{sec}F" else "F"), 1]
        else if str.substr( pos, 4 ).match( /^WI(C|T)Z$/ )
          return ["#{if pri? then pri else ''}TS", "#{if sec? then sec else ''}FX", 4]
        else
          return [pri, sec, 1]
      when 'X'
        current = ( if str.substr( pos + 1, 1 ).match( /^C|X$/ ) then 2 else 1 )
        if !(last == pos && ( str.substr( pos - 3, 3 ).match( /^(I|E)AU$/ ) || str.substr( pos - 2, 2 ).match( /^(A|O)U$/ )))
          return ['KS', 'KS', current]
        else
          return [null, null, current]
      when 'Z'
        if 'H' == str.substr( pos + 1, 1 )
          return ['J', 'J', 2]
        else
          current = (if 'Z' == str.substr( pos + 1, 1 ) then 2 else 1)
          if str.substr( pos + 1, 2 ).match( /^Z(O|I|A)$/ ) || (TEXT_TOOLS._is_slavo_germanic(str) && (pos > 0 && 'T' != str.substr( pos - 1, 1 )))
            return ['S', 'TS', current]
          else
            return ['S', 'S', current]
      else
        return [null, null, 1]
