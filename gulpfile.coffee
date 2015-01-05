"use strict"

## -- Dependencies -------------------------------------------------------------

gulp         = require 'gulp'
yml          = require 'gulp-yml'
gutil        = require 'gulp-util'
coffee       = require 'gulp-coffee'
concat       = require 'gulp-concat'
header       = require 'gulp-header'
uglify       = require 'gulp-uglify'
stylus       = require 'gulp-stylus'
flatten      = require 'gulp-flatten'
nodemon      = require 'gulp-nodemon'
pkg          = require './package.json'
autoprefixer = require 'gulp-autoprefixer'

## -- Files --------------------------------------------------------------------

assets = "static/"
pkg.name = "site"
source =
  coffee: [
    "source/app.coffee"
    "source/app.*.coffee"
  ]
  styl: [
    "bower_components/STYLmethods/vendor.styl"
    "source/styles/flexo.theme.styl"
    "source/styles/app.*.styl"
  ]

dependencies =
  js: [
    "bower_components/wow/dist/wow.min.js"
    "bower_components/parrotjs/dist/parrot.jquery.js"
    "bower_components/parrot-module-device/dist/parrot.device.js"
    "bower_components/jQuery-FireFly/jquery.firefly.js"
  ]
  css: [
    "bower_components/flexo/dist/flexo.css"
    "bower_components/animate.css/animate.min.css"
  ]
  fonts: [
    "dependencies/atoms.icons/fonts/*"
    "dependencies/icomoon/fonts/*"
  ]

banner = [
  "/**"
  " * <%= pkg.name %>"
  " * @version v<%= pkg.version %>"
  " */"
  ""
].join("\n")

# -- TASKS ---------------------------------------------------------------------

gulp.task "dependencies", ->
  gulp.src dependencies.js
    .pipe concat(pkg.name + ".dependencies.js")
    .pipe uglify(mangle: false)
    .pipe header(banner, pkg: pkg)
    .pipe gulp.dest(assets + "/js")


  gulp.src dependencies.css
    .pipe concat(pkg.name + ".dependencies.css")
    .pipe autoprefixer()
    .pipe header(banner,pkg: pkg)
    .pipe gulp.dest(assets + "/css")

  gulp.src dependencies.fonts
    .pipe gulp.dest(assets + "/css/fonts")

  return

gulp.task "coffee", ->
  gulp.src source.coffee
    .pipe concat(pkg.name + ".coffee")
    .pipe coffee().on("error", gutil.log)
    .pipe uglify(mangle: false)
    .pipe header(banner, pkg: pkg)
    .pipe gulp.dest(assets + "/js")

  return

gulp.task "styl", ->
  gulp.src source.styl
    .pipe concat(pkg.name + ".styl")
    .pipe stylus(compress: true, errors: true)
    .pipe autoprefixer()
    .pipe header(banner,pkg: pkg)
    .pipe gulp.dest(assets + "/css")
  return

gulp.task "build", ->
  gulp.start ["dependencies", "coffee", "styl"]
  return

gulp.task "watch", ->
  gulp.watch source.coffee, ["coffee"]
  gulp.watch source.styl, ["styl"]
  return

gulp.task "server", ->
  nodemon
    script : 'zen.js'
    args   : ['zen', 'development']
    ext    : 'mustache coffee js'
    ignore : '.git'

gulp.task "default", ->
  gulp.start ["build", "watch"]
  return