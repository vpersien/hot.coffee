Testing hot.coffee
==================

Require stuff:

    chai = require 'chai'
    Heatmap = require '../heatmap'


We are going to use the BDD "should" syntax for assertions:

    chai.should()


This div container will be used throughout most of our test cases:

    div = document.createElement 'div'
    div.id = 'heatmap'
    document.body.appendChild(div)


Let's start!

    describe 'Heatmap', () ->



Testing the constructor
-----------------------

First, we are going to test whether all properties are set correctly on
construction. At this point, we are not going to test anything regarding data
manipulation or visualization. Therefore, the div container, its selector and
the data will be fix this section.

        describe '#constructor()', () ->
            selector = '#heatmap'

            data = [
                [1, 2, 3]
                [4, 5, 6]
                [7, 8, 9]
                ]


Let us now check if the selector and the data remained unchanged.

            it 'should leave the data unchanged on construction', () ->
                heatmap = new Heatmap selector, data

                heatmap.data.should.equal data


            it 'should leave the selector unchanged on construction', () ->
                heatmap = new Heatmap selector, data

                heatmap.selector.should.equal selector

If no options are provided, the default options shall be set.

            it 'should also have its default options set', () ->
                heatmap = new Heatmap selector, data

                heatmap.options.should.eql Heatmap::defaults

If, however, options are provided, these shall be set instead.

            it 'should have all options set on construction', () ->
                options =
                    cellSize: 4
                    colorCold: '#000000'
                    colorHot: '#ffffff'
                    colorRange: ['#000000', '#ffffff']

                heatmap = new Heatmap selector, data, options

                heatmap.options.should.eql options


Testing the pre-processing
--------------------------

In order to map data to something visual, it has to be transformed into other data.

        describe '#preprocessData()', () ->
            selector = '#heatmap'
            data = [
                [1, 2, 3, 4]
                [5, 6, 7, 8]
                [9,10,11,12]
                ]

            heatmap = new Heatmap selector, data

            it 'should assign a row count of 3', () ->
                heatmap.rows.should.equal 3

            it 'should assign a column count of 4', () ->
                heatmap.cols.should.equal 4

            it 'should have computed a minimum value of 1', () ->
                heatmap.minValue.should.equal 1

            it 'should have computed a maximum value of 12', () ->
                heatmap.maxValue.should.equal 12



Testing SVG initialization
--------------------------

        describe '#initSVG()', () ->
            heatmap = null

            before () ->
                selector = '#heatmap'
                data = [
                    [1, 2, 3, 4]
                    [5, 6, 7, 8]
                    [9,10,11,12]
                    ]
                options = { cellSize: 12 }

                heatmap = new Heatmap selector, data, options


            it 'should result in a width of 48px', () ->
                heatmap.svg.attr('width').should.equal '48'

            it 'should result in a height of 36', () ->
                heatmap.svg.attr('height').should.equal '36'
