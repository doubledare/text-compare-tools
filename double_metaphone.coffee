TEXT_TOOLS = {} unless TEXT_TOOLS?

TEXT_TOOLS.doubleMetaphone = ( str )->
  primary = []
  secondary = []
  current = 0

  original = str + "     "
  length = str.length
  last = str.length - 1
  original = original.toUpperCase()
  if(original.substr(0,2).match(/^GN|KN|PN|WR|PS$/ ))
    current += 1
  if('X' == original[0])
    primary.push('S')
    secondary.push('S')
    current += 1
  while( primary.length < 4 || secondary.length < 4 )
    break if current > str.length
    [a,b,c] = TEXT_TOOLS._double_metaphone_lookup(original, current, length, last)
    primary.push( a ) if a?
    secondary.push( b ) if b?
    current += c if c?
  primary = primary.join( "" ).substr( 0, 4 )
  secondary = secondary.join( "" ).substr( 0, 4 )
  return [primary, (primary == secondary ? null : secondary)]

TEXT_TOOLS._is_vowel = ( str )->
  str.match( /^A|E|I|O|U|Y$/ )

TEXT_TOOLS._double_metaphone_lookup = ( str, pos, length, last )->
  switch str.substr(pos, 1)
    when /^A|E|I|O|U|Y$/
      if 0 == pos
        return ['A', 'A', 1]
      else
        return [null, null, 1]
    when 'B'
      return ['P', 'P', ('B' == str.substr( pos + 1, 1) ? 2 : 1)]
    when 'Ç'
      return ['S', 'S', 1]
    # when 'C'
    #   if pos > 1 && !TEXT_TOOLS._is_vowel( str.substr( pos - 2, 1 )) && 'ACH' == str.substr( pos - 1, 3 ) && str.substr( pos + 2, 1 ) != 'I' && ( str.substr( pos + 2, 1 ) != 'E' || str.substr( pos - 2, 6 ).match( /^(B|M)ACHER$/ ) )
    #     return ['K', 'K', 2]
    #   else if 0 == pos && 'CAESAR' == str.substr( pos, 6 )
    #     return ['S', 'S', 2]
    #   else if 'CHIA' == str.substr( pos, 4 )
    #     return ['K', 'K', 2]
    #   else if 'CH' == str.substr( pos, 2 )
    #     if pos > 0 && 'CHAE' == str.substr( pos, 4 )
    #       return ['K', 'X', 2]
    #     else if pos == 0 && ( ['HARAC', 'HARIS'].include?(str.substr( pos + 1, 5 )) ||
    #         ['HOR', 'HYM', 'HIA', 'HEM'].include?(str.substr( pos + 1, 3 ))) && str.substr( 0, 5 ) != 'CHORE'
    #       return ['K', 'K', 2]
    #     else if ['VAN ','VON '].include?(str.substr( 0, 4 )) || 'SCH' == str.substr( 0, 3 ) ||
    #           ['ORCHES','ARCHIT','ORCHID'].include?(str.substr( pos - 2, 6 )) ||
    #           ['T','S'].include?(str.substr( pos + 2, 1 )) || (
    #             ((0 == pos) || ['A','O','U','E'].include?(str.substr( pos - 1, 1 ))) &&
    #             ['L','R','N','M','B','H','F','V','W',' '].include?(str.substr( pos + 2, 1 )))
    #       return ['K', 'K', 2]
    #     else if pos > 0
    #       return [('MC' == str.substr( 0, 2 ) ? 'K' : 'X'), 'K', 2]
    #     else
    #       return ['X', 'X', 2]
    #   else if 'CZ' == str.substr( pos, 2 ) && 'WICZ' != str.substr( pos - 2, 4 )
    #     return ['S', 'X', 2]
    #   else if 'CIA' == str.substr( pos + 1, 3 )
    #     return ['X', 'X', 3]
    #   else if 'CC' == str.substr( pos, 2 ) && !(1 == pos && 'M' == str.substr( 0, 1 ))
    #     if str.substr( pos + 2, 1 ).match(/^I|E|H$/) && 'HU' != str.substr( pos + 2, 2 )
    #       if (pos == 1 && 'A' == str.substr( pos - 1, 1 )) || str.substr( pos - 1, 5 ).match(/^UCCE(E|S)$/)
    #         return ['KS', 'KS', 3]
    #       else
    #         return ['X', 'X', 3]
    #     else
    #       return ['K', 'K', 2]
    #   else if str.substr( pos, 2 ).match( /^C(K|G|Q)$/ )
    #     return ['K', 'K', 2]
    #   else if str.substr( pos, 2 ).match( /^C(I|E|Y)$/ )
    #     return ['S', (str.substr( pos, 3 ).match( /^CI(O|E|A)$/ ) ? 'X' : 'S'), 2]
    #   else
    #     if str.substr( pos + 1, 2 ).match( /^ (C|Q|G)$/ )
    #       return ['K', 'K', 3]
    #     else
    #       # return ['K', 'K', ( str.substr( pos + 1, 1 ).match( /^C|K|Q$/ ) && (['CE','CI'].indexOf(str.substr( pos + 1, 2 )) < 0) ? 2 : 1)]
    #       console.log  "THINGY"
    #       return ['K', 'K', 1]
    when 'D'
      if 'DG' == str.substr( pos, 2 )
        if str.substr( pos + 2, 1 ).match(/^I|E|Y$/)
          return ['J', 'J', 3]
        else
          return ['TK', 'TK', 2]
      else
        return ['T', 'T', (str.substr( pos, 2 ).match(/^D(T|D)$/) ? 2 : 1)]
  #   when 'F'
  #     return :F, :F, ('F' == str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'G'
  #     if 'H' == str.substr( pos + 1, 1]
  #       if pos > 0 && !vowel?(str.substr( pos - 1, 1])
  #         return :K, :K, 2
  #       elsif 0 == pos
  #         if 'I' == str.substr( pos + 2, 1]
  #           return 'J', 'J', 2
  #         else
  #           return :K, :K, 2
  #       elsif (pos > 1 && /^B|H|D$/ =~ str.substr( pos - 2, 1]) ||
  #             (pos > 2 && /^B|H|D$/ =~ str.substr( pos - 3, 1]) ||
  #             (pos > 3 && /^B|H$/   =~ str.substr( pos - 4, 1])
  #         return null, null, 2
  #       else
  #         if (pos > 2 && 'U' == str.substr( pos - 1, 1] && /^C|G|L|R|T$/ =~ str.substr( pos - 3, 1])
  #           return :F, :F, 2
  #         elsif pos > 0 && 'I' != str.substr( pos - 1, 1]
  #           return :K, :K, 2
  #         else
  #           return null, null, 2
  #     elsif 'N' == str.substr( pos + 1, 1]
  #       if 1 == pos && vowel?(str.substr( 0, 1]) && !slavo_germanic?(str)
  #         return :KN, :N, 2
  #       else
  #         if 'EY' != str.substr( pos + 2, 2] && 'Y' != str.substr( pos + 1, 1] && !slavo_germanic?(str)
  #           return :N, :KN, 2
  #         else
  #           return :KN, :KN, 2
  #     elsif 'LI' == str.substr( pos + 1, 2] && !slavo_germanic?(str)
  #       return :KL, :L, 2
  #     elsif 0 == pos && ('Y' == str.substr( pos + 1, 1] || /^(E(S|P|B|L|Y|I|R)|I(B|L|N|E))$/ =~ str.substr( pos + 1, 2])
  #       return :K, 'J', 2
  #     elsif (('ER' == str.substr( pos + 1, 2] || 'Y' == str.substr( pos + 1, 1]) &&
  #            /^(D|R|M)ANGER$/ !~ str.substr( 0, 6] &&
  #            /^E|I$/ !~ str.substr( pos - 1, 1] &&
  #            /^(R|O)GY$/ !~ str.substr( pos - 1, 3])
  #       return :K, 'J', 2
  #     elsif /^E|I|Y$/ =~ str.substr( pos + 1, 1] || /^(A|O)GGI$/ =~ str.substr( pos - 1, 4]
  #       if (/^V(A|O)N $/ =~ str.substr( 0, 4] || 'SCH' == str.substr( 0, 3]) || 'ET' == str.substr( pos + 1, 2]
  #         return :K, :K, 2
  #       else
  #         if 'IER ' == str.substr( pos + 1, 4]
  #           return 'J', 'J', 2
  #         else
  #           return 'J', :K, 2
  #     elsif 'G' == str.substr( pos + 1, 1]
  #       return :K, :K, 2
  #     else
  #       return :K, :K, 1
  #   when 'H'
  #     if (0 == pos || vowel?(str.substr( pos - 1, 1])) && vowel?(str.substr( pos + 1, 1])
  #       return :H, :H, 2
  #     else
  #       return null, null, 1
  #   when 'J'
  #     if 'JOSE' == str.substr( pos, 4] || 'SAN ' == str.substr( 0, 4]
  #       if (0 == pos && ' ' == str.substr( pos + 4, 1]) || 'SAN ' == str.substr( 0, 4]
  #         return :H, :H, 1
  #       else
  #         return 'J', :H, 1
  #     else
  #       current = ('J' == str.substr( pos + 1, 1] ? 2 : 1)

  #       if 0 == pos && 'JOSE' != str.substr( pos, 4]
  #         return 'J', :A, current
  #       else
  #         if vowel?(str.substr( pos - 1, 1]) && !slavo_germanic?(str) && /^A|O$/ =~ str.substr( pos + 1, 1]
  #           return 'J', :H, current
  #         else
  #           if last == pos
  #             return 'J', null, current
  #           else
  #             if /^L|T|K|S|N|M|B|Z$/ !~ str.substr( pos + 1, 1] && /^S|K|L$/ !~ str.substr( pos - 1, 1]
  #               return 'J', 'J', current
  #             else
  #               return null, null, current
  #   when 'K'
  #     return :K, :K, ('K' == str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'L'
  #     if 'L' == str.substr( pos + 1, 1]
  #       if (((length - 3) == pos && /^(ILL(O|A)|ALLE)$/ =~ str.substr( pos - 1, 4]) ||
  #           ((/^(A|O)S$/ =~ str.substr( last - 1, 2] || /^A|O$/ =~ str.substr( last, 1]) && 'ALLE' == str.substr( pos - 1, 4]))
  #         return :L, null, 2
  #       else
  #         return :L, :L, 2
  #     else
  #       return :L, :L, 1
  #   when 'M'
  #     if ('UMB' == str.substr( pos - 1, 3] &&
  #         ((last - 1) == pos || 'ER' == str.substr( pos + 2, 2])) || 'M' == str.substr( pos + 1, 1]
  #       return :M, :M, 2
  #     else
  #       return :M, :M, 1
  #   when 'N'
  #     return :N, :N, ('N' == str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'Ñ'
  #     return :N, :N, 1
  #   when 'P'
  #     if 'H' == str.substr( pos + 1, 1]
  #       return :F, :F, 2
  #     else
  #       return :P, :P, (/^P|B$/ =~ str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'Q'
  #     return :K, :K, ('Q' == str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'R'
  #     current = ('R' == str.substr( pos + 1, 1] ? 2 : 1)

  #     if last == pos && !slavo_germanic?(str) && 'IE' == str.substr( pos - 2, 2] && /^M(E|A)$/ !~ str.substr( pos - 4, 2]
  #       return null, :R, current
  #     else
  #       return :R, :R, current
  #   when 'S'
  #     if /^(I|Y)SL$/ =~ str.substr( pos - 1, 3]
  #       return null, null, 1
  #     elsif 0 == pos && 'SUGAR' == str.substr( pos, 5]
  #       return :X, :S, 1
  #     elsif 'SH' == str.substr( pos, 2]
  #       if /^H(EIM|OEK|OLM|OLZ)$/ =~ str.substr( pos + 1, 4]
  #         return :S, :S, 2
  #       else
  #         return :X, :X, 2
  #     elsif /^SI(O|A)$/ =~ str.substr( pos, 3] || 'SIAN' == str.substr( pos, 4]
  #       return :S, (slavo_germanic?(str) ? :S : :X), 3
  #     elsif (0 == pos && /^M|N|L|W$/ =~ str.substr( pos + 1, 1]) || 'Z' == str.substr( pos + 1, 1]
  #       return :S, :X, ('Z' == str.substr( pos + 1, 1] ? 2 : 1)
  #     elsif 'SC' == str.substr( pos, 2]
  #       if 'H' == str.substr( pos + 2, 1]
  #         if /^OO|ER|EN|UY|ED|EM$/ =~ str.substr( pos + 3, 2]
  #           return (/^E(R|N)$/ =~ str.substr( pos + 3, 2] ? :X : :SK), :SK, 3
  #         else
  #           return :X, ((0 == pos && !vowel?(str.substr( 3, 1]) && ('W' != str.substr( pos + 3, 1])) ? :S : :X), 3
  #       elsif /^I|E|Y$/ =~ str.substr( pos + 2, 1]
  #         return :S, :S, 3
  #       else
  #         return :SK, :SK, 3
  #     else
  #       return (last == pos && /^(A|O)I$/ =~ str.substr( pos - 2, 2] ? null : 'S'), 'S', (/^S|Z$/ =~ str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'T'
  #     if 'TION' == str.substr( pos, 4]
  #       return :X, :X, 3
  #     elsif /^T(IA|CH)$/ =~ str.substr( pos, 3]
  #       return :X, :X, 3
  #     elsif 'TH' == str.substr( pos, 2] || 'TTH' == str.substr( pos, 3]
  #       if /^(O|A)M$/ =~ str.substr( pos + 2, 2] || /^V(A|O)N $/ =~ str.substr( 0, 4] || 'SCH' == str.substr( 0, 3]
  #         return 'T', 'T', 2
  #       else
  #         return 0, 'T', 2
  #     else
  #       return 'T', 'T', (/^T|D$/ =~ str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'V'
  #     return :F, :F, ('V' == str.substr( pos + 1, 1] ? 2 : 1)
  #   when 'W'
  #     if 'WR' == str.substr( pos, 2]
  #       return :R, :R, 2
  #     pri, sec = null, null

  #     if 0 == pos && (vowel?(str.substr( pos + 1, 1]) || 'WH' == str.substr( pos, 2])
  #       pri = :A
  #       sec = vowel?(str.substr( pos + 1, 1]) ? :F : :A

  #     if (last == pos && vowel?(str.substr( pos - 1, 1])) || 'SCH' == str.substr( 0, 3] ||
  #         /^EWSKI|EWSKY|OWSKI|OWSKY$/ =~ str.substr( pos - 1, 5]
  #       return pri, "#{sec}F".intern, 1
  #     elsif /^WI(C|T)Z$/ =~ str.substr( pos, 4]
  #       return "#{pri}TS".intern, "#{sec}FX".intern, 4
  #     else
  #       return pri, sec, 1
  #   when 'X'
  #     current = (/^C|X$/ =~ str.substr( pos + 1, 1] ? 2 : 1)

  #     if !(last == pos && (/^(I|E)AU$/ =~ str.substr( pos - 3, 3] || /^(A|O)U$/ =~ str.substr( pos - 2, 2]))
  #       return :KS, :KS, current
  #     else
  #       return null, null, current
  #   when 'Z'
  #     if 'H' == str.substr( pos + 1, 1]
  #       return 'J', 'J', 2
  #     else
  #       current = ('Z' == str.substr( pos + 1, 1] ? 2 : 1)

  #       if /^Z(O|I|A)$/ =~ str.substr( pos + 1, 2] || (slavo_germanic?(str) && (pos > 0 && 'T' != str.substr( pos - 1, 1]))
  #         return :S, 'T'S, current
  #       else
  #         return :S, :S, current
    else
      return [null, null, 1]
