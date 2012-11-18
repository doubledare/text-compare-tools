/*
	This is the Text Tools package.
	It provides functions to helping in comparing strings.
*/
if( typeof TEXT_TOOLS === "undefined" ) {
	TEXT_TOOLS = {};
}

/*
	Soundex
*/
TEXT_TOOLS.soundex = function( str_or_arr ) {
	if( _.isString( str_or_arr ) ) {
		return TEXT_TOOLS._soundexStr( str_or_arr );
	} else if ( _.isArray( str_or_arr ) ) {
		return _.reduce( str_or_arr, function(memo, str) {
			return memo + TEXT_TOOLS._soundexStr( str );
		}, "");
	} else {
		return null;
	}
};

TEXT_TOOLS._soundexStr = function( str ) {
	str = str.toUpperCase();
	last_code = TEXT_TOOLS._get_code( str.substr( 0, 1 ) );
	soundex_code = str.substr( 0, 1 );
	for (var i = 1; i <= str.length; i++) {
		if( soundex_code.length == 4 ) {
			return soundex_code;
		}
		code = TEXT_TOOLS._get_code( str.substr( i, 1 ) );
		if (code == "0") {
			last_code = null;
		}
		else if (code === null)
		{
			return null;
		}
		else if (code != last_code)
		{
			soundex_code += code;
			last_code = code;
		}
	}
	var result = soundex_code + "000";
	result = result.substr( 0, 4 );
	return result;
};

TEXT_TOOLS._FROM_STRING = "AEIOUYWHBPFVCSKGJQXZDTLMNR";
TEXT_TOOLS._TO_STRING =   "00000000111122222222334556";

TEXT_TOOLS._get_code = function( str ) {
	var result = "";
	idx = TEXT_TOOLS._FROM_STRING.indexOf( str );
	if( idx > -1 ) {
		result = TEXT_TOOLS._TO_STRING.substr( idx, 1 );
	}
	return result;
};
/*
	Metaphone
*/
TEXT_TOOLS.metaphone = function( str ) {
	var words = str.split(/\s+/);
	var results = _.map( words, function (txt) { return TEXT_TOOLS._metaphone_word( txt ); } );
	return results.join(' ');
};

TEXT_TOOLS.metaphone_rules_STANDARD = [
      // # Regexp, replacement
      [ /([bcdfhjklmnpqrstvwxyz])\1+/g, '$1' ],
      [ /^ae/,            'E' ],
      [ /^[gkp]n/,        'N' ],
      [ /^wr/,            'R' ],
      [ /^x/,             'S' ],
      [ /^wh/,            'W' ],
      [ /mb$/,            'M' ],  //# [PHP] remove $ from regexp.
      [ /(?!^)sch/,      'SK' ],
      [ /th/,             '0' ],
      [ /t?ch|sh/,        'X' ],
      [ /c(?=ia)/,        'X' ],
      [ /[st](?=i[ao])/,  'X' ],
      [ /s?c(?=[iey])/,   'S' ],
      [ /[cq]/,           'K' ],
      [ /dg(?=[iey])/,    'J' ],
      [ /d/,              'T' ],
      [ /g(?=h[^aeiou])/, ''  ],
      [ /gn(ed)?/,        'N' ],
      [ /([^g]|^)g(?=[iey])/, '$1J' ],
      [ /g+/g,             'K' ],
      [ /ph/,             'F' ],
      [ /([aeiou])h(?=\b|[^aeiou])/, '$1' ],
      [ /[wy](?![aeiou])/g, '' ],
      [ /z/,              'S' ],
      [ /v/,              'F' ],
      [ /(?!^)[aeiou]+/g,  ''  ]
    ];

TEXT_TOOLS._metaphone_word = function (text) {
	var s = text.toLowerCase().replace(/[^a-z]/g, '');
	rules = TEXT_TOOLS.metaphone_rules_STANDARD;
	_.each( rules, function(item) {
		s = s.replace( item[0], item[1] );
	});
	return s.toUpperCase();
};

TEXT_TOOLS.whiteSimilarity = function( str1, str2 ) {
	var pairs1 = TEXT_TOOLS._word_letter_pairs( str1 );
	var pairs2 = TEXT_TOOLS._word_letter_pairs( str2 );
	var union = pairs1.length + pairs2.length;
	var intersection = 0;
	_.each( pairs1, function(element, index, list) {
		var findIndex = _.indexOf( pairs2, element );
		if ( findIndex > -1 ) {
			pairs2.splice( findIndex, 1 );
			intersection += 1;
		}
	});
	return ( 2.0 * intersection ) / union;
};

TEXT_TOOLS._word_letter_pairs = function( str ) {
	var words = str.toUpperCase().split(/\s+/g);
	var mainResult = _.map( words, function( word ) {
		var letters = word.split("");
		var pairs = _.zip( _.initial(letters), _.rest(letters) );
		var result = _.map(pairs, function(i) {return i[0] + i[1];} );
		return result;
	});
	return _.flatten( mainResult );
};