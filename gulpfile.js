'use strict'

var gulp = require('gulp')
var imageResize = require('gulp-image-resize')
var rename = require('gulp-rename')

gulp.task('resize', function() {
  gulp.src(['./img/portfolio/*.jpg', '!./img/portfolio/*-thumbnail.jpg'])
    .pipe(imageResize({
      width: 400,
      height: 289,
      crop: true,
      upscale: false,
      imageMagick: true
    }))
    .pipe(rename({
      suffix: '-thumbnail'
    }))
    .pipe(gulp.dest('./img/portfolio'))
})

gulp.task('default', ['resize'])
