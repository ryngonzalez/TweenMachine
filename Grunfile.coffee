module.exports = (grunt) ->

    files = [
        'src/*.coffee'
        'src/support/*.coffee'
        'src/progress/*.coffee'
    ]

    grunt.initConfig
        pkg: grunt.file.readJSON 'package.json'

        watch:
            sass:
                files: 'app/styles/scss/**'
                tasks: ['sass']

            coffee:
                files: [
                    'app/scripts/coffee/**'
                    'core/app/scripts/coffee/**'
                ]
                tasks: ['buildDevelopmentJS']

            tests:
                files: [
                    'test/coffee/**'
                    'core/test/coffee/**'
                ]
                tasks: ['test:build']

        sass:
            dist:
                options:
                    style: 'compressed'
                files:
                    'app/styles/css/main.css': [
                        'app/styles/scss/app.scss'
                    ]

        coffee:
            prod:
                options:
                    join: true
                files:
                    'app/scripts/js/app.compiled.tmp.js': productionCoffee
            dev:
                options:
                    join: true
                files:
                    'app/scripts/js/app.compiled.tmp.js': developmentCoffee
            e2e:
                options:
                    join: true
                files:
                    'test/js/e2e/scenarios.js': [
                        'test/coffee/e2e/utils.coffee'
                        'test/coffee/e2e/*.coffee'
                    ]
            unit:
                expand: true
                cwd: 'test/coffee/unit'
                src: '**/*.coffee'
                dest: 'test/js/unit/'
                ext: '.js'
            core:
                options:
                    join: true
                files:
                    'test/js/unit/core.js': coreTests

        uglify:
            dist:
                files: 'app/scripts/js/app.js': [
                    'app/scripts/js/app.compiled.tmp.js'
                ]

        copy:
            images:
                files: [
                    {
                        expand: true
                        cwd: 'app/images'
                        src: ['**']
                        dest: 'forge/src/images'
                    }
                ]
            index:
                files: [
                    {
                        expand: true
                        cwd: 'app/'
                        src: ['index.html']
                        dest: 'forge/src/'
                        filter: 'isFile'
                    }
                ]
            libraries:
                files: [
                    {
                        expand: true
                        cwd: 'app/libraries'
                        src: ['**']
                        dest: 'forge/src/libraries'
                    }
                ]
            scripts:
                files: [
                    {
                        expand: true
                        cwd: 'app/scripts/js/'
                        src: ['**']
                        dest: 'forge/src/scripts/js'
                        filter: 'isFile'
                    }
                ]
            devJS:
                files: [
                    {
                        src: ['app/scripts/js/app.compiled.tmp.js']
                        dest: 'app/scripts/js/app.js'
                    }
                ]
            styles:
                files: [
                    {
                        expand: true
                        cwd: 'app/styles/'
                        src: ['css/**']
                        dest: 'forge/src/styles'
                    }
                ]
            views:
                files: [
                    {
                        expand: true
                        cwd: 'app/views'
                        src: ['**']
                        dest: 'forge/src/views'
                        filter: 'isFile'
                    }
                ]
        clean:
            build: [
                'app/styles/css/main.css'
                'app/scripts/js/'
            ]
            tmp: ['app/scripts/js/*.tmp.js']
            test: [
                'test/js/e2e/'
                'test/js/unit/'
                'test/coverage/'
            ]

        exec:
            forgeBuild:
                cmd: ->
                    "cd forge && \"$HOME/Library/Trigger\ Toolkit/forge\" build ios"
            forgeRun:
                cmd: ->
                    "cd forge && \"$HOME/Library/Trigger\ Toolkit/forge\" run ios -v"
            forgePackage:
                cmd: ->
                    "cd forge && \"$HOME/Library/Trigger\ Toolkit/forge\" package ios --profile -v release && open release/ios/"

            forgeList:
                cmd: ->
                    "cd forge && \"$HOME/Library/Trigger\ Toolkit/forge\" reload list"
            forgeBuildReload:
                cmd: ->
                    "cd forge && \"$HOME/Library/Trigger\ Toolkit/forge\" build reload"
            forgeReload:
                cmd: (stream) ->
                    "cd forge && \"$HOME/Library/Trigger\ Toolkit/forge\" reload push #{stream}"

            testUnit:
                cmd: ->
                    'test/scripts/test.sh'
            testE2e:
                cmd: ->
                    'test/scripts/e2e-test.sh'
            testCoverage:
                cmd: ->
                    'test/scripts/coverage.sh'

            server:
                cmd: (port) ->
                    "cd app/ && python -m SimpleHTTPServer #{port or 8000}"

            coreInit:
                cmd: ->
                    'mkdir core && git clone git@github.com:Fetchnotes/fetchnotes-core.git core/'
            corePull:
                cmd: ->
                    'cd core/ && git pull'

    grunt.loadNpmTasks 'grunt-contrib-sass'
    grunt.loadNpmTasks 'grunt-contrib-watch'
    grunt.loadNpmTasks 'grunt-contrib-coffee'
    grunt.loadNpmTasks 'grunt-contrib-copy'
    grunt.loadNpmTasks 'grunt-contrib-uglify'
    grunt.loadNpmTasks 'grunt-contrib-clean'
    grunt.loadNpmTasks 'grunt-exec'

    grunt.registerTask 'updateVersion', 'Update the version ok', (args...) ->
        config = grunt.file.readJSON 'forge/src/config.json'
        grunt.file.write 'app/scripts/coffee/version.coffee', "# Generated file. Don't edit.\n\nFetchnotes or (Fetchnotes = {})\nFetchnotes.version = '#{config.version}'\n"

    # Manage fetchnotes-core
    grunt.registerTask 'core:init', 'exec:coreInit'
    grunt.registerTask 'core:pull', 'exec:corePull'

    grunt.registerTask 'buildProductionJS', ['coffee:prod', 'uglify:dist', 'clean:tmp']
    grunt.registerTask 'buildDevelopmentJS', ['coffee:dev', 'copy:devJS', 'clean:tmp']

    ## Web ##
    grunt.registerTask 'default', ['sass', 'test:build', 'buildDevelopmentJS']
    grunt.registerTask 'production', ['updateVersion', 'sass', 'test:build', 'buildProductionJS']

    ## Forge ##
    grunt.registerTask 'copyToForge', ['copy:images', 'copy:index', 'copy:libraries', 'copy:scripts', 'copy:styles', 'copy:views']
    grunt.registerTask 'forge', ['default', 'copyToForge']
    grunt.registerTask 'forge:production', ['production', 'copyToForge']
    grunt.registerTask 'forge:run', ['forge', 'exec:forgeBuild', 'exec:forgeRun']
    grunt.registerTask 'forge:package', ['core:pull', 'forge:production', 'exec:forgeBuild', 'exec:forgePackage']

    ## Forge Reload ##
    grunt.registerTask 'forge:reload:list', 'exec:forgeList'
    grunt.registerTask 'forge:reload:team', ['forge:production', 'exec:forgeBuildReload', 'exec:forgeReload:Team', 'exec:forgeReload:Schiff']
    grunt.registerTask 'forge:reload:schiff', ['forge:production', 'exec:forgeBuildReload', 'exec:forgeReload:Schiff']
    grunt.registerTask 'forge:reload:all', ['forge:production', 'exec:forgeBuildReload', 'exec:forgeReload:default']

    ## Tests ##
    grunt.registerTask 'test:build', ['coffee:e2e', 'coffee:unit', 'coffee:core']
    grunt.registerTask 'test:unit', 'exec:testUnit'
    grunt.registerTask 'test:e2e', 'exec:testE2e'
    grunt.registerTask 'test:coverage', 'exec:testCoverage'
