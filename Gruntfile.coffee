
"use strict"

module.exports = (grunt) ->

  require("load-grunt-tasks")(grunt)

  grunt.initConfig

    clean:
      dist:
        dot: true
        src: [
          ".tmp"
          "dist/*"
          "!dist/.git"
        ]

    copy:
      dist:
        files: [
          expand: true
          src: ["views/**"]
          dest: "dist"
        ]

    bowerInstall:
      target:
        src: "views/layout.jade"
        ignorePath: "../public"

    rev:
      dist:
        files:
          src: [ 
            "dist/js/{,*/}*.js"
          ]

    useminPrepare:
      html: ["views/layout.jade"]
      options:
        dest: "dist"
        
    usemin:
      html: ["dist/views/layout.jade"]
      options:
        assetsDirs: ["dist"]

  grunt.registerTask "bower", "bowerInstall"

  grunt.registerTask "build", [
    "clean:dist"
    "copy:dist"
    "useminPrepare"
    "concat"
    "uglify"
    "rev"
    "usemin"
  ]
