module.exports = function (grunt) {
    var outputFolder = 'app';
    var sourceFolder = 'src/';
    var banner = '/* Developed under Apache 2 License, compiled on <%= grunt.template.today("mm/yyyy") %> */ \n';
    //set all the grunt information
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        copy: {
            release: {
                files: [{
                    expand: true,
                    cwd: sourceFolder,
                    src: ['**/*', '!**/*.{html,js,css,json,scss,coffee}', '!**/ignore_*'],
                    dest: outputFolder + '/',
                    dot: true
                }]
            },
            json: {
                options: {
                    process: function (content, srcpath) {
                        // minify json
                        return JSON.stringify(JSON.parse(content.replace(/(\r|\n)+/g, ' ')));
                    }
                },
                files: [{
                    expand: true,
                    cwd: sourceFolder,
                    src: ['**/*.json'],
                    dest: outputFolder + '/'
                }]
            }
        },
        uglify: {
            release: {
                options: {
                    banner: banner,
                    compress: false,
                    mangle: false,
                    screwIE8: true,
                    quoteStyle: 3
                },
                files: [{
                    expand: true,
                    cwd: 'src',
                    src: '**/*.js',
                    dest: outputFolder + '/'
                }]
            }
        },
        coffee: {
            release: {
                options: {
                    banner: banner,
                    compress: false,
                    mangle: false,
                    screwIE8: true,
                    quoteStyle: 3
                },
                files: [{
                    expand: true,
                    cwd: 'src',
                    src: '**/*.coffee',
                    ext: '.js',
                    dest: outputFolder + '/'
                }]
            }
        },
        htmlmin: {
            release: {
                options: {
                    removeComments: true,
                    collapseWhitespace: true
                },
                files: [{
                    expand: true,
                    cwd: 'src',
                    src: '**/*.html',
                    dest: outputFolder + '/'
                }]
            }
        },
        cssmin: {
            release: {
                options: {
                    banner: banner
                },
                files: [{
                    expand: true,
                    cwd: 'src',
                    src: '**/*.css',
                    dest: outputFolder + '/'
                }]
            }
        },
        sass: {
            release: {
                options: {
                    style: 'compressed'
                },
                files: [{
                    expand: true,
                    cwd: 'src',
                    src: '**/*.scss',
                    dest: outputFolder + '/',
                    ext: '.css'
                }]
            }
        },
        watch: {
            main: {
                files: 'src/**/*',
                tasks: ['default']
            }
        }
    });

    //load the required uglify plugin
    grunt.loadNpmTasks('grunt-shell');
    grunt.loadNpmTasks('grunt-newer');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-htmlmin');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-watch');


    //define the task query
    grunt.registerTask('default', [
        'newer:copy:release',
        'newer:uglify:release',
        'newer:coffee:release',
        'newer:htmlmin:release',
        'newer:cssmin:release',
        'newer:sass:release',
        'newer:copy:json'
    ]);

};
