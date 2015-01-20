# Generated on 2015-01-16 using generator-cloudant-talk 0.1.1
module.exports = (grunt) ->

    grunt.initConfig

        watch:

            livereload:
                options:
                    livereload: true
                files: [
                    'index.html'
                    'slides/{,*/}*.{md,html}'
                    'js/*.js'
                    'images/**'
                    'video/**'
                ]

            index:
                files: [
                    'templates/_index.html'
                    'templates/_section.html'
                    'slides/list.json'
                ]
                tasks: ['buildIndex']

            coffeelint:
                files: ['Gruntfile.coffee']
                tasks: ['coffeelint']

            jshint:
                files: ['js/*.js']
                tasks: ['jshint']

        connect:

            livereload:
                options:
                    port: 9000
                    # Change hostname to '0.0.0.0' to access
                    # the server from outside.
                    hostname: 'localhost'
                    base: '.'
                    open: true
                    livereload: true

        coffeelint:

            options:
                indentation:
                    value: 4
                max_line_length:
                    level: 'ignore'

            all: ['Gruntfile.coffee']

        jshint:

            options:
                jshintrc: '.jshintrc'

            all: ['js/*.js']

        copy:

            dist:
                files: [{
                    expand: true
                    src: [
                        'slides/**'
                        'bower_components/**'
                        'js/**'
                        'images/**'
                        'css/**'
                        'video/**'
                    ]
                    dest: 'dist/'
                },{
                    expand: true
                    src: ['index.html']
                    dest: 'dist/'
                    filter: 'isFile'
                }]

        manifest:

            generate:
                options:
                    timestamp: true
                    exclude: [
                      'bower_components/reveal.js/plugin/leap'
                      'bower_components/reveal.js/plugin/leap/leap.js'
                      'bower_components/reveal.js/test'
                      'bower_components/reveal.js/test/examples'
                      'bower_components/reveal.js/test/examples/assets'
                      'bower_components/reveal.js/test/examples/assets/image1.png'
                      'bower_components/reveal.js/test/examples/assets/image2.png'
                      'bower_components/reveal.js/test/examples/barebones.html'
                      'bower_components/reveal.js/test/examples/embedded-media.html'
                      'bower_components/reveal.js/test/examples/math.html'
                      'bower_components/reveal.js/test/examples/slide-backgrounds.html'
                      'bower_components/reveal.js/test/qunit-1.12.0.css'
                      'bower_components/reveal.js/test/qunit-1.12.0.js'
                      'bower_components/reveal.js/test/test-markdown-element-attributes.html'
                      'bower_components/reveal.js/test/test-markdown-element-attributes.js'
                      'bower_components/reveal.js/test/test-markdown-slide-attributes.html'
                      'bower_components/reveal.js/test/test-markdown-slide-attributes.js'
                      'bower_components/reveal.js/test/test-markdown.html'
                      'bower_components/reveal.js/test/test-markdown.js'
                      'bower_components/reveal.js/test/test.html'
                      'bower_components/reveal.js/test/test.js'
                    ]
                src: [
                    'css/**'
                    'bower_components/**'
                    'js/**'
                    'images/**'
                    'video/**'
                    'slides/**'
                    'index.html'
                ]
                dest: 'dist/cache.manifest'

        buildcontrol:

            options:
                dir: 'dist'
                commit: true
                push: true
                message: 'Built from %sourceCommit% on branch %sourceBranch%'
            pages:
                options:
                    remote: 'git@github.com:ukmadlz/a-new-look-at-data.git'
                    branch: 'gh-pages'

    # Load all grunt tasks.
    require('load-grunt-tasks')(grunt)

    grunt.registerTask 'buildIndex',
        'Build index.html from templates/_index.html and slides/list.json.',
        ->
            indexTemplate = grunt.file.read 'templates/_index.html'
            sectionTemplate = grunt.file.read 'templates/_section.html'
            slides = grunt.file.readJSON 'slides/list.json'

            html = grunt.template.process indexTemplate, data:
                slides:
                    slides
                section: (slide) ->
                    grunt.template.process sectionTemplate, data:
                        slide:
                            slide
            grunt.file.write 'index.html', html

    grunt.registerTask 'test',
        '*Lint* javascript and coffee files.', [
            'coffeelint'
            'jshint'
        ]

    grunt.registerTask 'serve',
        'Run presentation locally and start watch process (living document).', [
            'buildIndex'
            'connect:livereload'
            'watch'
        ]

    grunt.registerTask 'dist',
        'Save presentation files to *dist* directory.', [
            'manifest'
            'test'
            'buildIndex'
            'copy'
        ]

    grunt.registerTask 'deploy',
        'Deploy to Github Pages', [
            'dist'
            'buildcontrol'
        ]


    # Define default task.
    grunt.registerTask 'default', [
        'test'
        'serve'
    ]
