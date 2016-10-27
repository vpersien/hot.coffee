*heatmap.litcoffee*

# A simple heatmap module

This module provides a simple class which takes a numerical 2D array of size n*m
and turns it into a beautiful SVG matrix.


## Imports

Import d3.js and underscore.js.

    d3 = require 'd3'
    _ = require 'underscore'


## The main part

### Class definition and initialization

Let us begin by defining a new class `Heatmap`.

    class Heatmap
        @cellSize = 4
        @colorCold = '#000'
        @colorHot = '#fff'


On construction, the constructor has to be passed a unique CSS selector (e.g. `#foo`)
as well as an n*m array of data.

        constructor: (@selector, @data) ->
            @cellSize = 4
            @colorCold = '#000'
            @colorHot = '#fff'

            @preprocessData()
            @initColorScale()
            @initSVG()
            @buildHeatmap()


First, the data has to be preprocessed, because we need the number of its rows and
columns as well as, for palette generation, the minimum and maximum value.

        preprocessData: () ->
            @rows = @data.length
            @cols = @data[0].length

            @maxValue = _.max (_.max row for row in @data)
            @minValue = _.min (_.min row for row in @data)


Now, we can create ourselves a nice color scale based on the min and max values

        initColorScale: () ->
            @colorScale = d3.scale.linear()
                .domain([@minValue, @maxValue])
                .range([@colorCold, @colorHot])


Then, we want to initialize the canvas the heatmap is drawn upon.

        initSVG: () ->
            @selection = d3.select(@selector)
                .attr(
                    width: @cellSize * @rows
                    height: @cellSize * @cols
                    )

            @svg = @selection.append 'svg'
            @container = @svg.append 'g'


### Building the heatmap

Now, it is time to finally draw something.

        buildHeatmap: () ->

At first, we add a container for every row each of which are subsequently filled
with cells (i.e. squares)

            rows = @container.selectAll('.heatmap-row')
                .data(@data)
                .enter().append('g')
                    .attr(
                        class: 'heatmap-row'
                        x: @x(0)
                        y: (d,i) => @y(i)
                        )

            cells = rows.selectAll('.heatmap-cell')
                .data((d,i) -> d)
                .enter().append('rect')
                    .attr(
                        class: 'heatmap-cell'
                        x: (d,i) => @x(i)
                        y: () -> d3.select(@parentNode).attr('y')
                        width: @cellSize
                        height: @cellSize
                        fill: (d) => @colorScale d
                        )



### Little helpers

        x: (i) -> i*@cellSize
        y: (i) -> i*@cellSize



#Scribbling area

    data = [[1,2,3],[1,3,5],[9,8,7]]

    heatmap = new Heatmap('#heatmap', data)


    #Please remove me later, thanks!
