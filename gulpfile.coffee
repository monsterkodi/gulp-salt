gulp   = require 'gulp'
salt   = require './'
coffee = require 'gulp-coffee'
bump   = require 'gulp-bump'

gulp.task 'default', ->
                
    gulp.watch 'index.coffee', (e) ->
        gulp.src(e.path) .pipe(coffee({bare: true})) .pipe(gulp.dest '.')

gulp.task 'salt', ->
    gulp.src 'index.coffee'
    .pipe salt()
    .pipe gulp.dest '.'

gulp.task 'coffee', ->
    gulp.src 'index.coffee'
    .pipe coffee bare: true
    .pipe gulp.dest '.'

gulp.task 'bump', ->
    gulp.src 'package.json'
    .pipe bump()
    .pipe gulp.dest '.'
