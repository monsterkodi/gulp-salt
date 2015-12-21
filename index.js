'use strict';
var _, asciiJoin, asciiLines, font, log, path, salt, thru, util;

_ = require('lodash');

path = require('path');

thru = require('through2');

util = require('gulp-util');

font = require('./font.json');

log = util.log;


/*
 0000000   000   000  000      00000000            0000000   0000000   000      000000000
000        000   000  000      000   000          000       000   000  000         000   
000  0000  000   000  000      00000000   000000  0000000   000000000  000         000   
000   000  000   000  000      000                     000  000   000  000         000   
 0000000    0000000   0000000  000                0000000   000   000  0000000     000
 */

module.exports = function(options) {
  var opts;
  opts = _.assign({
    coffee: {
      marker: '#!!',
      prefix: '###',
      postfix: '###'
    },
    styl: {
      marker: '//!',
      prefix: '/*',
      fill: '*  ',
      postfix: '*/'
    }
  }, options);
  return thru.obj(function(file, enc, cb) {
    var ext, salted;
    if (!file.isNull() && !file.isStream()) {
      ext = path.extname(file.path).substr(1);
      if (opts[ext] == null) {
        ext = 'coffee';
      }
      salted = salt(file.contents.toString('utf8'), opts[ext]);
      file.contents = new Buffer(salted);
    }
    return cb(null, file);
  });
};


/*
 0000000   0000000   000      000000000
000       000   000  000         000   
0000000   000000000  000         000   
     000  000   000  000         000   
0000000   000   000  0000000     000
 */

asciiLines = function(s, options) {
  var c, cs, i, len, rs, zs;
  s = s.toLowerCase().trim();
  cs = [];
  for (i = 0, len = s.length; i < len; i++) {
    c = s[i];
    if (font[c] != null) {
      cs.push(font[c]);
    }
  }
  zs = _.zip.apply(null, cs);
  rs = _.map(zs, function(j) {
    return j.join('  ');
  });
  if ((options.character != null) && options.character.length === 1) {
    rs = _.map(rs, function(l) {
      return l.replace(/0/g, options.character);
    });
  }
  return rs;
};

asciiJoin = function(l) {
  return "\n" + l.join('\n') + "\n";
};

salt = function(s, options) {
  var i, k, l, len, li, lines, lns, m, r, ref, salted;
  lines = s.split('\n');
  salted = [];
  r = new RegExp('^(\\s*)(' + options.marker + ")", 'i');
  for (li = i = 0, ref = lines.length; 0 <= ref ? i < ref : i > ref; li = 0 <= ref ? ++i : --i) {
    if (m = lines[li].match(r)) {
      lns = asciiLines(lines[li].slice(m[1].length + options.marker.length), options);
      if (options.verbose) {
        log(asciiJoin(lns));
      }
      if (options.prefix != null) {
        salted.push(m[1] + options.prefix);
      }
      for (k = 0, len = lns.length; k < len; k++) {
        l = lns[k];
        salted.push(m[1] + ((options.fill != null) && options.fill || '') + l);
      }
      if (options.postfix != null) {
        salted.push(m[1] + options.postfix);
      }
    } else {
      salted.push(lines[li]);
    }
  }
  return salted.join('\n');
};
