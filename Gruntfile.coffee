path = require('path')

module.exports = (grunt)->
    ###############################################################
    # Constants
    ###############################################################

    PROFILE = grunt.option('profile') || 'dev'

    SRC_DIR =                       'src'
    SRC_APP_DIR =                   "#{SRC_DIR}/app"
    SRC_SERVER_DIR =                "#{SRC_DIR}/server"

    BUILD_DIR =                     "dist"
    BUILD_APP_DIR =                 "#{BUILD_DIR}/app"
    BUILD_SERVER_DIR =              "#{BUILD_DIR}/server"    
    BUILD_ENV_PROVIDER_PATH =       "#{BUILD_APP_DIR}/common/services/envProvider.coffee"
    
    APP_CSS_PATH =                  "#{BUILD_APP_DIR}/style/app.css"
    APP_JS_PATH =                   "#{BUILD_APP_DIR}/js/app.js"
    
    SERVER_PATH =                   "#{BUILD_SERVER_DIR}/express"

    ###############################################################
    # Config
    ###############################################################

    grunt.initConfig
        clean:
            main:
                src: BUILD_DIR
            after_build_app:
                src: ["#{BUILD_APP_DIR}/**/*.coffee", "#{BUILD_APP_DIR}/**/*.jade"]

        copy:
            app:
                files: [
                    expand: true
                    cwd: SRC_APP_DIR
                    src: "**"
                    dest: "#{BUILD_APP_DIR}/"
                ]

        replace:
            dev:
                options:
                    variables:
                        "ENV_NAME": "dev localhost"
                        "ENV_GOOGLE_CLIENT_ID": "525964413214-9s58fe969e54t670gsi9pjrq2bphet6v.apps.googleusercontent.com"
                        "ENV_GOOGLE_REDIRECT_URI": "http://localhost:8000"
                files: [
                    src: [BUILD_ENV_PROVIDER_PATH]
                    dest: BUILD_ENV_PROVIDER_PATH
                ]
            heroku:
                options:
                    variables:
                        "ENV_NAME": "heroku"
                        "ENV_GOOGLE_CLIENT_ID": "525964413214-jrc04fjcde7kdd903dhe9ujnr68p7hg3.apps.googleusercontent.com"
                        "ENV_GOOGLE_REDIRECT_URI": "http://paulcompta.heroku.com"
                files: [
                    src: [BUILD_ENV_PROVIDER_PATH]
                    dest: BUILD_ENV_PROVIDER_PATH
                ]
                                    
        concat:
            app_css:
                src: "#{BUILD_APP_DIR}/**/*.css"
                dest: APP_CSS_PATH

        coffee:
            app:
                src: "#{BUILD_APP_DIR}/**/*.coffee"
                dest: APP_JS_PATH
            server:
                expand: true
                flatten: true
                cwd: "#{SRC_SERVER_DIR}"
                src: ['*.coffee']
                dest: "#{BUILD_SERVER_DIR}/"
                ext: '.js'

        jade:
            dist:
                options:
                    client: false
                    pretty: true
                    basePath: "#{BUILD_APP_DIR}/"
                src: "#{BUILD_APP_DIR}/**/*.jade"
                dest: "#{BUILD_APP_DIR}/"

        uglify:
            app:
                src: APP_JS_PATH
                dest: APP_JS_PATH

        cssmin:
            app_css:
                src: APP_CSS_PATH
                dest: APP_CSS_PATH

        express:
            livereload:
                options:
                    port: 8000
                    bases: [path.resolve(BUILD_APP_DIR)]
                    monitor: {}
                    debug: true
                    server: path.resolve(SERVER_PATH)

#        connect:
#            server:
#                options:
#                    base: BUILD_MAIN_DIR

        regarde:
            build_app_dev:
                options:
                    base: BUILD_DIR
                files: ["#{SRC_APP_DIR}/**/*.{css,coffee,js,html,jade}"]
                tasks: ['build_app_dev', 'livereload']
            build_server_dev:
                options:
                    base: BUILD_DIR
                files: ["#{SRC_SERVER_DIR}/**/*.{coffee}"]
                tasks: ['build_server_dev', 'livereload']
                
            #Note, disabling this until https://github.com/mklabs/tiny-lr/issues/8 is resolved
            #livereload:
                #files: ["#{BUILD_APP_DIR}/**/*.{css,js,html}"]
                #tasks: ['livereload']

    ##############################################################
    # Dependencies
    ###############################################################
    grunt.loadNpmTasks('grunt-jade')
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.loadNpmTasks('grunt-contrib-clean')
    grunt.loadNpmTasks('grunt-contrib-concat')
    grunt.loadNpmTasks('grunt-contrib-uglify')
    grunt.loadNpmTasks('grunt-contrib-cssmin')
    grunt.loadNpmTasks('grunt-contrib-connect')
    grunt.loadNpmTasks('grunt-contrib-livereload')
    grunt.loadNpmTasks('grunt-express')
    grunt.loadNpmTasks('grunt-regarde')
    grunt.loadNpmTasks('grunt-replace')

    ###############################################################
    # Alias tasks
    ###############################################################

    for env in ['dev', 'heroku']
        grunt.registerTask("build_app_#{env}", ['copy', "replace:#{env}", 'concat', 'coffee:app', 'jade', 'clean:after_build_app'])
        grunt.registerTask('build_server', ['coffee:server'])
        grunt.registerTask("build_#{env}", ["build_app_#{env}", 'build_server'])

    grunt.registerTask('watcher_dev', ['livereload-start', 'express', 'regarde']) 

    for env in ['dev', 'heroku']
        grunt.registerTask("dist_#{env}", ["clean:main", "build_#{env}", 'uglify', 'cssmin'])

    grunt.registerTask('default', ['clean:main', 'build_dev', 'watcher_dev'])
    grunt.registerTask('heroku', ['dist_heroku']);
