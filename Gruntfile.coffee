path = require('path')

console.log process.env.ENV_GOOGLE_CLIENT_ID
console.log process.env.ENV_GOOGLE_REDIRECT_URI

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
            after_build:
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
            app:
                options:
                    variables:
                        "ENV_GOOGLE_CLIENT_ID": process.env.ENV_GOOGLE_CLIENT_ID
                        "ENV_GOOGLE_REDIRECT_URI": process.env.ENV_GOOGLE_REDIRECT_URI
                files: [
                    src: ["#{BUILD_APP_DIR}/common/services/envProvider.coffee"]
                    dest: "#{BUILD_APP_DIR}/common/services/envProvider.coffee"
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
            build:
                options:
                    base: BUILD_DIR
                files: ["#{SRC_DIR}/**/*.{css,coffee,js,html,jade}"]
                tasks: ['build', 'livereload']
                
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

    grunt.registerTask('build', ['copy', 'replace', 'concat', 'coffee', 'jade', 'clean:after_build'])
    grunt.registerTask('watcher', ['livereload-start', 'express', 'regarde']) 
    grunt.registerTask('dist', ['build', 'uglify', 'cssmin'])

    grunt.registerTask('default', ['clean:main', 'build', 'watcher'])
    grunt.registerTask('heroku', ['dist']);



