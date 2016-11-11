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


These will be the basic options to be provided by the user.

        defaults:
            cellSize: 8
            colorCold: '#081d58'
            colorHot: '#ffffd9'
            colorRange: ['#ffffd9','#edf8b1','#c7e9b4','#7fcdbb','#41b6c4','#1d91c0','#225ea8','#253494','#081d58']



On construction, the constructor has to be passed a unique CSS selector (e.g. `#foo`)
as well as an n*m array of data.

        constructor: (@selector, @data, options={}) ->
            @configure options

            @preprocessData()
            @initColorScale()
            @initSVG()
            @buildHeatmap()
            @initTooltip()


Merge user provided options and defaults into a new options object.

This general technique is taken from the [Docco source](https://jashkenas.github.io/docco/).

        configure: (options) ->
            @options = _.extend {}, @defaults, _.pick(options, _.keys(@defaults)...)


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
                .range([@options.colorRange[@options.colorRange.length-1], @options.colorRange[0]])


Then, we want to initialize the canvas the heatmap is drawn upon.

        initSVG: () ->
            @selection = d3.select(@selector)

            @svg = @selection.append 'svg'
                .attr(
                    width: @options.cellSize * @cols
                    height: @options.cellSize * @rows
                    )

            @container = @svg.append 'g'


### Building the heatmap

Now, it is time to finally draw something.

        buildHeatmap: () ->

At first, we add a container for every row, each of which is subsequently filled
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
                        width: @options.cellSize
                        height: @options.cellSize
                        fill: (d) => @colorScale d
                        )
                    .on(
                        mouseover: @onCellMouseOver
                        mouseout: @onCellMouseOut
                        )

In order to display the actual data and not only colors derived from it, a tooltip
with the corresponding value shall be shown everytime the user hovers over a cell.

        onCellMouseOver: (d,i) =>
            @showTooltip(d,i)

        onCellMouseOut: (d,i) =>
            @hideTooltip(d,i)


The tooltip is a simple div the opacity of which is initially 0 and is set to
something more visible in case of a cell mouse over event. At the same time,
the position, based on the current position of the mouse pointer, is also updated.

        initTooltip: () ->
            @tooltip = d3.select('body').append('div')
                .attr('class', 'tooltip')
                .style('opacity', 0)

            @tooltipTemplate = (value) -> "<b>#{value}</b>"

        showTooltip: (d,i) ->
            x = d3.event.pageX
            y = d3.event.pageY

            @tooltip
                .style(
                    left: (x + 5) + 'px'
                    top: (y - 25) + 'px'
                    )
                .html(@tooltipTemplate(d))
                .transition()
                    .duration(200)
                    .style('opacity', 0.9)

        hideTooltip: (d,i) ->
            @tooltip.transition()
                .duration(500)
                .style('opacity', 0)



### Little helpers

        x: (i) -> i*@options.cellSize
        y: (i) -> i*@options.cellSize


### Export

    module.exports = Heatmap
