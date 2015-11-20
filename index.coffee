'use strict'

_    = require 'lodash'
path = require 'path'
thru = require 'through2'
util = require 'gulp-util'
log  = util.log

module.exports = (options) ->
    
    opts = _.assign
        coffee: 
            marker:  '#!!'
            prefix:  '###'
            postfix: '###'
        styl: 
            marker:  '//!'
            prefix:  '/*'
            fill:    '*  '
            postfix: '*/'
    ,
        options
    
    thru.obj (file, enc, cb) ->
        
        if file.isFile()
            ext = path.extname(file.path).substr 1
            ext = 'coffee' if not opts[ext]?
            salted = salt file.contents.toString('utf8'), opts[ext]
            file.contents = new Buffer salted
            
        cb null, file

###
 0000000   0000000   000      000000000
000       000   000  000         000   
0000000   000000000  000         000   
     000  000   000  000         000   
0000000   000   000  0000000     000   
###

asciiLines = (s, options) ->
        s = s.toLowerCase()
        cs = (chars[c.charCodeAt(0)-97].split('\n') for c in s when 97 <= c.charCodeAt(0) < 97+26)
        zs = _.zip.apply(null, cs)
        rs = _.map(zs, (j) -> j.join('  '))
        if options.character? and options.character.length == 1
            rs = _.map(rs, (l) -> l.replace(/0/g, options.character))
        rs
    
asciiJoin = (l) -> "\n"+l.join('\n')+"\n"

salt = (s, options) ->

    lines = s.split '\n'
    salted = []
    r = new RegExp('^(\\s*)(' + options.marker + ")", 'i')
    for li in [0...lines.length]
        if m = lines[li].match(r)
            lns = asciiLines(lines[li].slice(m[1].length+options.marker.length), options)
            if options.verbose
                log asciiJoin(lns)
            salted.push m[1] + options.prefix if options.prefix?
            for l in lns
                salted.push m[1] + (options.fill? and options.fill or '') + l
            salted.push m[1] + options.postfix if options.postfix?
        else
            salted.push lines[li]
        
    salted.join('\n')
                        
###
00000000   0000000   000   000  000000000
000       000   000  0000  000     000   
000000    000   000  000 0 000     000   
000       000   000  000  0000     000   
000        0000000   000   000     000   
###

chars = [ \
"""
\ 0000000 
000   000
000000000
000   000
000   000
""","""
0000000  
000   000
0000000  
000   000
0000000  
""","""
\ 0000000
000     
000     
000     
 0000000
""","""
0000000  
000   000
000   000
000   000
0000000  
""","""
00000000
000     
0000000 
000     
00000000
""","""
00000000
000     
000000  
000     
000     
""","""
\ 0000000 
000      
000  0000
000   000
 0000000 
""","""
000   000
000   000
000000000
000   000
000   000
""","""
000
000
000
000
000
""","""
\      000
      000
      000
000   000
 0000000 
""","""
000   000
000  000 
0000000  
000  000 
000   000
""","""
000    
000    
000    
000    
0000000
""","""
00     00
000   000
000000000
000 0 000
000   000
""","""
000   000
0000  000
000 0 000
000  0000
000   000
""","""
\ 0000000 
000   000
000   000
000   000
 0000000 
""","""
00000000 
000   000
00000000 
000      
000      
""","""
\ 0000000 
000   000
000 00 00
000 0000 
 00000 00
""","""
00000000 
000   000
0000000  
000   000
000   000
""","""
\ 0000000
000     
0000000 
     000
0000000 
""","""
000000000
   000   
   000   
   000   
   000   
""","""
000   000
000   000
000   000
000   000
 0000000 
""","""
000   000
000   000
 000 000 
   000   
    0    
""","""
000   000
000 0 000
000000000
000   000
00     00
""","""
000   000
 000 000 
  00000  
 000 000 
000   000
""","""
000   000
 000 000 
  00000  
   000   
   000   
""","""
0000000
   000 
  000  
 000   
0000000
"""
]
