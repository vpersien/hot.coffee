module.exports = function(grunt) {
    grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),

        coffee: {
            compile: {
                files: {
                    'intermediate/heatmap.js': 'heatmap.litcoffee'
                }
            }
        },

        browserify: {
            options: {
                browserifyOptions: {
                    standalone: 'Heatmap',
                    debug: true
                }
            },
            compile: {
                src: 'intermediate/heatmap.js',
                dest: 'intermediate/heatmap-browserified.js'
            }
        },

        uglify: {
            prod: {
                src: 'intermediate/heatmap-browserified.js',
                dest: 'build/heatmap.js'
            }
        },

        copy: {
            dev: {
                src: 'intermediate/heatmap-browserified.js',
                dest: 'build/heatmap.js'
            }
        },

        watch: {
            options: {
                livereload: true
            },

            dev: {
                files: ['heatmap.litcoffee'],
                tasks: ['dev']
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-copy');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-browserify');

    grunt.registerTask('default', ['coffee', 'browserify', 'copy'])
    grunt.registerTask('dev', ['coffee', 'browserify', 'copy'])
    grunt.registerTask('prod', ['coffee', 'browserify', 'uglify']);
}
