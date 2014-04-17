text-compare-tools
==================

Overview
--------

Initially a JavaScript/CoffeeScript port of [threedaymonk's text library](https://github.com/threedaymonk/text), written in ruby. 
Currently has code for Soundex, Metaphone, Double Metaphone and Whitespace Similarity.

Usage
-----

Run:

    mrt add text-compare-tools

You can then run `mrt list --using` to make sure you have the package.

Text Tools provides several methods to help with text comparison.

    Soundex
    Metaphone
    Double Metaphone
    White space similarity
    
    
With more to follow...

To use TEXT_TOOLS, put something similar to the following in your code:

    TEXT_TOOLS.doubleMetaphone( "Rachel" );

And you will get back the primary and secondary results:

    ["RXL", RKL]

For many words you may get a null value for the secondary result.

Testing
-------

Once you have Meteorite and Meteor installed then cd into this package and simply run

    mrt

on the command line. This will run the test server on localhost on the default port 3000.

Go to <http://localhost:3000/> in your favourite browser to see the tests run.



The tests will autorun if any files are changed.

License
-------

Three Day Monk's library was specified 'same as ruby'

Unless there is a problem I am publishing this code under the MIT License., do whatever you want but with it at your own risk.. etc.

Copyright 2012 Joc O'Connor
