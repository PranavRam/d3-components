gulp        = require 'gulp'
concat      = require 'gulp-concat'
es          = require('event-stream')
sass        = require 'gulp-sass'
uglify      = require 'gulp-uglify'
streamqueue = require 'streamqueue' # Preserves file order (vendor...)
coffee      = require 'gulp-coffee'
gutil       = require 'gulp-util'
shell       = require 'gulp-shell'
cssmin      = require 'gulp-cssmin'
coffeelint  = require 'gulp-coffeelint'
browserSync = require 'browser-sync'
slim = require 'gulp-slim'
gulpBowerFiles = require 'gulp-bower-files'
coffeeify = require 'gulp-coffeeify'

isProd = gutil.env.type is 'prod'

sources =
  sass: 'src/css/**/*.scss'
  css: 'src/css/**/*.css'
  html: 'src/**/*.slim'
  js: 'src/js/**/*.js'
  coffee: ['src/js/*.coffee', '!src/js/main1.coffee', '!src/js/main2.coffee']

targets =
  css: 'www/css'
  html: 'www/'
  js: 'www/js'

# Check for errors
gulp.task 'lint', ->
  gulp.src(sources.js)
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())

# Compile Coffeescript
gulp.task 'js', ->
  stream = streamqueue(objectMode: true)
  # Vendor files
  stream.queue(gulp.src(sources.js))
  # App files use Coffee
  # stream.queue(gulp.src(sources.coffee).pipe(coffee(bare:true)))
  stream.queue(gulp.src(sources.coffee).pipe(coffeeify()))
  stream.done()
    .pipe(concat("all.js"))
    .pipe(if isProd then uglify() else gutil.noop())
    .pipe(gulp.dest(targets.js))

# Compile Slim
gulp.task 'slim', ->
  gulp.src(sources.html)
    .pipe slim pretty: true
    .pipe gulp.dest './www'

# Compile CSS
gulp.task 'css', ->
  stream = streamqueue(objectMode: true)
  # Vendor files
  stream.queue(gulp.src(sources.css))
  # App files
  stream.queue(gulp.src(sources.sass).pipe(sass(style: 'expanded', includePaths: ['src/css'], errLogToConsole: true)))
  stream.done()
    .pipe(concat("all.css"))
    .pipe(if isProd then uglify() else gutil.noop())
    .pipe(gulp.dest(targets.css))

# Reload browser
gulp.task 'server', ->
  browserSync
    open: true
    server:
      baseDir: targets.html
    reloadDelay: 2000 # Prevent white screen of death
    watchOptions:
      debounceDelay: 1000

# Watch files for changes
gulp.task 'watch', ->
  gulp.watch sources.js, ['js']
  gulp.watch sources.coffee, ['js']
  gulp.watch sources.css, ['css']
  gulp.watch sources.html, ['slim']
  gulp.watch 'www/**/**', (file) ->
    browserSync.reload(file.path) if file.type is "changed"

gulp.task 'bower-files', ->
  gulpBowerFiles()
    .pipe(gulp.dest('www/lib'))


# Build everything
gulp.task 'build', ['lint', 'js', 'css', 'slim']

# Start a server and watch for file changes
gulp.task 'default', ['watch', 'server']