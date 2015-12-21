gulp   = require 'gulp'
salt   = require './'
fs     = require 'fs'
coffee = require 'gulp-coffee'
bump   = require 'gulp-bump'
util   = require 'gulp-util'
log    = util.log

gulp.task 'salt', ->
    gulp.src 'index.coffee'
    .pipe salt()
    .pipe gulp.dest '.'

gulp.task 'coffee', ->
    gulp.src 'index.coffee'
    .pipe coffee bare: true
    .pipe gulp.dest '.'

gulp.task 'noon', ->
    noon = require 'noon'
    font = JSON.stringify noon.load('font.noon'), null, '    '
    fs.writeFileSync 'font.json', font, 'utf8'

gulp.task 'bump', ->
    gulp.src 'package.json'
    .pipe bump()
    .pipe gulp.dest '.'

gulp.task 'default', ->
    gulp.watch 'index.coffee', (e) ->
        gulp.src(e.path) .pipe(coffee({bare: true})) .pipe(gulp.dest '.')

gulp.task 'release', ['noon', 'coffee'], ->
