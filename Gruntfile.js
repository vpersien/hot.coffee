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
            compile: {
                src: 'intermediate/heatmap.js',
                dest: 'intermediate/heatmap-browserified.js'
            }
        },

        uglify: {
            compile: {
                src: 'intermediate/heatmap-browserified.js',
                dest: 'build/heatmap.js'
            }
        }
    });

    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-browserify');

    grunt.registerTask('default', ['coffee', 'browserify', 'uglify']);
}
