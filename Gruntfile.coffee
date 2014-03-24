module.exports = (grunt) ->

  files = [
    'src/tweenmachine.coffee'
    'src/*.coffee'
  ]

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    watch:

      coffee:
        files: files
        tasks: ['default']

    coffee:
      build:
        options:
          join: true
        files:
          'tweenmachine.js': files

    uglify:
      production:
        files: 'tweenmachine.min.js': ['tweenmachine.js']

    clean:
      js: ['tweenmachine.js', 'tweenmachine.min.js']

  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-uglify'
  grunt.loadNpmTasks 'grunt-contrib-clean'

  grunt.registerTask 'build:development', ['coffee:build']
  grunt.registerTask 'build:production', ['coffee:build', 'uglify:production']
  grunt.registerTask 'default', ['build:production']
