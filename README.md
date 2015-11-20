# gulp-salt

generates ascii-font headers like this:

```coffee
###
 0000000   0000000   000      000000000
000       000   000  000         000   
0000000   000000000  000         000   
     000  000   000  000         000   
0000000   000   000  0000000     000   
###
```

when it discovers special comment lines:
```coffee
#!! salt
```

it is most useful when attached to a watch:

#### gulpfile.coffee

```coffee
gulp = require 'gulp'
salt = require 'gulp-salt'

gulp.task 'default', ->        
    gulp.watch ['**/*.coffee'], (e) -> 
        gulp.src e.path, base: './'
        .pipe salt()
        .pipe gulp.dest '.'
```

it keeps the indentation level intact and you can configure
the comment format for different file types:

#### default config

```coffee
coffee: 
    marker:  '#!!'
    prefix:  '###'
    postfix: '###'
styl: 
    marker:  '//!'
    prefix:  '/*'
    fill:    '*  '
    postfix: '*/'
```

This stuff works for me, but I won't guarantee that it works for you as well. 
Use at your own risk!

[npm](https://www.npmjs.com/package/gulp-salt)
