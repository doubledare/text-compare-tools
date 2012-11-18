// Generated by CoffeeScript 1.3.1
var TEXT_TOOLS;

if (typeof TEXT_TOOLS === "undefined" || TEXT_TOOLS === null) {
  TEXT_TOOLS = {};
}

TEXT_TOOLS.doubleMetaphone = function(str) {
  var a, b, c, current, last, length, original, primary, secondary, _ref, _ref1;
  primary = [];
  secondary = [];
  current = 0;
  original = str + "     ";
  length = str.length;
  last = str.length - 1;
  original = original.toUpperCase();
  if (original.substr(0, 2).match(/^GN|KN|PN|WR|PS$/)) {
    current += 1;
  }
  if ('X' === original[0]) {
    primary.push('S');
    secondary.push('S');
    current += 1;
  }
  while (primary.length < 4 || secondary.length < 4) {
    if (current > str.length) {
      break;
    }
    _ref = TEXT_TOOLS._double_metaphone_lookup(original, current, length, last), a = _ref[0], b = _ref[1], c = _ref[2];
    if (a != null) {
      primary.push(a);
    }
    if (b != null) {
      secondary.push(b);
    }
    if (c != null) {
      current += c;
    }
  }
  primary = primary.join("").substr(0, 4);
  secondary = secondary.join("").substr(0, 4);
  return [
    primary, (_ref1 = primary === secondary) != null ? _ref1 : {
      "null": secondary
    }
  ];
};

TEXT_TOOLS._is_vowel = function(str) {
  return str.match(/^A|E|I|O|U|Y$/);
};

TEXT_TOOLS._double_metaphone_lookup = function(str, pos, length, last) {
  var _ref, _ref1;
  switch (str.substr(pos, 1)) {
    case /^A|E|I|O|U|Y$/:
      if (0 === pos) {
        return ['A', 'A', 1];
      } else {
        return [null, null, 1];
      }
      break;
    case 'B':
      return [
        'P', 'P', (_ref = 'B' === str.substr(pos + 1, 1)) != null ? _ref : {
          2: 1
        }
      ];
    case 'Ç':
      return ['S', 'S', 1];
    case 'D':
      if ('DG' === str.substr(pos, 2)) {
        if (str.substr(pos + 2, 1).match(/^I|E|Y$/)) {
          return ['J', 'J', 3];
        } else {
          return ['TK', 'TK', 2];
        }
      } else {
        return [
          'T', 'T', (_ref1 = str.substr(pos, 2).match(/^D(T|D)$/)) != null ? _ref1 : {
            2: 1
          }
        ];
      }
      break;
    default:
      return [null, null, 1];
  }
};