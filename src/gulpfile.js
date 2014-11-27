"use strict";

var gulp = require("gulp");
var path = require("path");
var del = require("del");
var ncp = require("ncp").ncp;

var $ = require("gulp-load-plugins")();

gulp.task("clean:before", function(cb) {
  del([
    "./build"
    ], cb);
}); 

gulp.task("clean:after", ["usemin"], function(cb) {
  del([
    "./app/*.js"
    ], cb);
});

gulp.task("coffee", ["clean:before"], function(cb) {
  return gulp.src(["./app/*.coffee"])
    .pipe($.coffee().on("error", $.util.log))
    .pipe($.ngAnnotate())
    .pipe(gulp.dest("./app"));
  cb(err);
});

gulp.task("usemin", ["coffee"], function () {
  return gulp.src("./views/index.jade")
    .pipe($.jadeUsemin({
      css: [$.autoprefixer(), $.csso(), $.rev()],
      lib: [$.uglify(), $.rev()],
      app: [$.uglify(), $.rev()]
    }))
    .pipe(gulp.dest('./build'));
});

gulp.task("fonts", ["clean:before"], function(cb) {
  return gulp.src("public/fonts/*")
    .pipe(gulp.dest("build/fonts/"))
});

gulp.task("imagemin", ["clean:before"], function(cb) {
  return gulp.src("./public/img/*")
    .pipe($.imagemin())
    .pipe(gulp.dest("build/img"))
});

gulp.task("copy", ["usemin"], function(cb){
  ncp("./views/partials", "./build/partials", function(err) {
    if (err) {
      return cb(err);
    }
    cb();
  });
});

gulp.task("default", ["clean:before", "imagemin", "fonts", "coffee", "usemin", "copy", "clean:after"]);




