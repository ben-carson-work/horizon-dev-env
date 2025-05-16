var gulp = require('gulp');
var gutil = require('gulp-util');
var bower = require('bower');
var concat = require('gulp-concat');
var sass = require('gulp-sass');
var minifyCss = require('gulp-minify-css');
var rename = require('gulp-rename');
var sh = require('shelljs');
var uglify = require('gulp-uglify');

var paths = {
  js: [
    /*
    './www/common/lib/ionic/js/ionic.bundle.min.js',
		'./www/common/lib/angular-cookies/angular-cookies.min.js',
		'./www/common/lib/ng-lodash/build/ng-lodash.min.js',
		'./www/common/lib/angular-load/angular-load.min.js',
		'./www/common/lib/jquery/dist/jquery.min.js',
    */
    './www/common/scripts/functions.js',
    './www/common/js/**/*.js',
    './www/mob_adm/js/**/*.js',
    './www/mob_pay/js/**/*.js',
    './www/mob_sales_operator/js/**/*.js'
  ],
  sass: ['./scss/**/*.scss']
};

gulp.task('default', ['sass']);

gulp.task('sass', function(done) {
  gulp.src('./scss/ionic.app.scss')
    .pipe(sass())
    .on('error', sass.logError)
    .pipe(gulp.dest('./www/common/css/'))
    .pipe(minifyCss({
      keepSpecialComments: 0
    }))
    .pipe(rename({ extname: '.min.css' }))
    .pipe(gulp.dest('./www/common/css/'))
    .on('end', done);
});

gulp.task('compact-js', function() {
  gulp.src(paths.js)
    .pipe(uglify())
    .pipe(concat('all.min.js'))
    .pipe(gulp.dest('./www/common/scripts/'))
});

gulp.task('watch', ['sass', 'compact-js'], function() {
  console.log('watching my sass and js files');
  console.log('env:', gutil.env);
  gulp.watch(paths.sass, ['sass']);
  
  if (gutil.env.env !== 'local') {
    gulp.watch(paths.js, ['compact-js']);
  }
});

// below line is to fix 'ionic setup sass' not working
gulp.task('serve:before',['watch']);

gulp.task('install', ['git-check'], function() {
  return bower.commands.install()
    .on('log', function(data) {
      gutil.log('bower', gutil.colors.cyan(data.id), data.message);
    });
});

gulp.task('git-check', function(done) {
  if (!sh.which('git')) {
    console.log(
      '  ' + gutil.colors.red('Git is not installed.'),
      '\n  Git, the version control system, is required to download Ionic.',
      '\n  Download git here:', gutil.colors.cyan('http://git-scm.com/downloads') + '.',
      '\n  Once git is installed, run \'' + gutil.colors.cyan('gulp install') + '\' again.'
    );
    process.exit(1);
  }
  done();
});
