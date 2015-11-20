gulp   = require 'gulp'
coffee = require 'gulp-coffee'

gulp.task 'default', ->
                
    gulp.watch 'index.coffee', (e) ->
        gulp.src(e.path) .pipe(coffee({bare: true})) .pipe(gulp.dest '.')

gulp.task 'coffee', ->
    gulp.src('index.coffee') 
    .pipe coffee({bare: true})
    .pipe gulp.dest '.'
