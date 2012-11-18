
Tinytest.add( "Soundex Tests", function( test ) {
	var test_cases = [
	"Euler", "E460",
	"Ellery", "E460",
	"Gauss", "G200",
	"Ghosh", "G200",
	"Hilbert", "H416",
	"Heilbronn", "H416",
	"Knuth", "K530",
	"Kant", "K530",
	"Lloyd", "L300",
	"Ladd", "L300",
	"Lukasiewicz", "L222",
	"Lissajous", "L222"
	];
	for(var i = 0; i < test_cases.length; i += 2) {
		var expected = test_cases[i + 1];
		var input = test_cases[i];
		test.equal( TEXT_TOOLS.soundex( input ), expected );
	}
});

Tinytest.add( "Metaphone Standard Tests", function( test ) {
	var test_cases = [
	// #
	// # Based on the table at http://aspell.net/metaphone/metaphone-kuhn.txt,
	// # with surprising results changed to 'correct' ones (according to my interpretation
	// # of the algorithm description), and some more results from around the web:
	// #
	"ANASTHA", "ANS0",
	"DAVIS-CARTER", "TFSKRTR",
	"ESCARMANT", "ESKRMNT",
	"MCCALL", "MKL",
	"MCCROREY", "MKRR",
	"MERSEAL", "MRSL",
	"PIEURISSAINT", "PRSNT",
	"ROTMAN", "RTMN",
	"SCHEVEL", "SXFL",
	"SCHROM", "SXRM",
	"SEAL", "SL",
	"SPARR", "SPR",
	"STARLEPER", "STRLPR",
	"THRASH", "0RX",
	"LOGGING", "LKNK",
	"LOGIC", "LJK",
	"JUDGES", "JJS",
	"SHOOS", "XS",
	"SHOES", "XS",
	"CHUTE", "XT",
	"SCHUSS", "SXS",
	"OTTO", "OT",
	"ERIC", "ERK",
	"DAVE", "TF",
	"CATHERINE", "K0RN",
	"KATHERINE", "K0RN",
	"AUBREY", "ABR",
	"BRYAN", "BRYN",
	"BRYCE", "BRS",
	"STEVEN", "STFN",
	"RICHARD", "RXRT",
	"HEIDI", "HT",
	"AUTO", "AT",
	"MAURICE", "MRS",
	"RANDY", "RNT",
	"CAMBRILLO", "KMBRL",
	"BRIAN", "BRN",
	"RAY", "R",
	"GEOFF", "JF",
	"BOB", "BB",
	"AHA", "AH",
	"AAH", "A",
	"PAUL", "PL",
	"BATTLEY", "BTL",
	"WROTE", "RT",
	"THIS", "0S"
	];
		for(var i = 0; i < test_cases.length; i += 2) {
		var expected = test_cases[i + 1];
		var input = test_cases[i];
		test.equal( TEXT_TOOLS.metaphone( input ), expected );
	}
});

Tinytest.add( "Metaphone Other Tests", function ( test ) {
	// test junk input
	test.equal( TEXT_TOOLS.metaphone('%^@#$^f%^&o%^o@b#a@#r%^^&'), TEXT_TOOLS.metaphone('foobar') );
	// test caps
	test.equal( TEXT_TOOLS.metaphone('FOOBAR'), TEXT_TOOLS.metaphone('foobar') );
	// test string of words
	test.equal( TEXT_TOOLS.metaphone('foo bar baz'), 'F BR BS' );
  test.equal( TEXT_TOOLS.metaphone('gnu what'), 'N WT' );
});

Tinytest.add( "private _word_letter_pairs tests", function( test ) {
	test.equal( TEXT_TOOLS._word_letter_pairs("france"), ["FR", "RA", "AN", "NC", "CE"] );
	test.equal( TEXT_TOOLS._word_letter_pairs("fr"), ["FR"] );
	test.equal( TEXT_TOOLS._word_letter_pairs("fr oops"), ["FR", "OO", "OP", "PS"] );
});

test_float = function( test, fl1, fl2 ) {
	test.equal( fl1.toFixed(2), fl2.toFixed(2) );
};

Tinytest.add( "White Similarity Tests", function ( test ) {
	var word = "Healed";
	test_float( test, 0.8, TEXT_TOOLS.whiteSimilarity( word, "Sealed" ) );
	test_float( test, 0.55, TEXT_TOOLS.whiteSimilarity( word, "Healthy" ) );
	test_float( test, 0.44, TEXT_TOOLS.whiteSimilarity( word, "Heard" ) );
	test_float( test, 0.40, TEXT_TOOLS.whiteSimilarity( word, "Herded" ) );
	test_float( test, 0.25, TEXT_TOOLS.whiteSimilarity( word, "Help" ) );
	test_float( test, 0.0, TEXT_TOOLS.whiteSimilarity( word, "Sold" ) );

  test_float( test, 0.4,  TEXT_TOOLS.whiteSimilarity("GGGGG", "GG") );
  test_float( test, 0.56, TEXT_TOOLS.whiteSimilarity("REPUBLIC OF FRANCE", "FRANCE") );
  test_float( test, 0.0,  TEXT_TOOLS.whiteSimilarity("FRANCE", "QUEBEC") );
  test_float( test, 0.72, TEXT_TOOLS.whiteSimilarity("FRENCH REPUBLIC", "REPUBLIC OF FRANCE") );
  test_float( test, 0.61, TEXT_TOOLS.whiteSimilarity("FRENCH REPUBLIC", "REPUBLIC OF CUBA") );

  test_float( test, 1.0, TEXT_TOOLS.whiteSimilarity("aaaaa", "aaaaa") );
  test_float( test, 1.0, TEXT_TOOLS.whiteSimilarity("REPUBLIC OF CUBA", "REPUBLIC OF CUBA") );
});

