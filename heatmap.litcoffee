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

On construction, the constructor has to be passed a unique CSS selector (e.g. `#foo`)
as well as an n*m array of data.

        constructor: (@selector, @data) ->
            @cellSize = 8
            @colorCold = '#081d58'
            @colorHot = '#ffffd9'

            @preprocessData()
            @initColorScale()
            @initSVG()
            @buildHeatmap()
            @initTooltip()


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
the position, based on the current position of the mouse pointer, is updated
as well.

        initTooltip: () ->
            @tooltip = d3.select('body').append('div')
                .attr('class', 'tooltip')
                .style('opacity', 0)

            @tooltipTemplate = _.template('<b><%= value %></b>')

        showTooltip: (d,i) ->
            x = d3.event.pageX
            y = d3.event.pageY

            @tooltip
                .style(
                    left: (x + 5) + 'px'
                    top: (y - 25) + 'px'
                    )
                .html(@tooltipTemplate({value: d}))
                .transition()
                    .duration(200)
                    .style('opacity', 0.9)

        hideTooltip: (d,i) ->
            @tooltip.transition()
                .duration(500)
                .style('opacity', 0)



### Little helpers

        x: (i) -> i*@cellSize
        y: (i) -> i*@cellSize



#Scribbling area

    data = [[  9.15238487e-01,   6.38015171e-01,   2.48646533e-01,
          6.18228796e-01,   5.71105900e-01,   9.54487422e-01,
          8.04678693e-01,   6.46224481e-01,   2.91634896e-01,
          8.20866736e-01],
       [  2.45798971e-02,   7.11704283e-01,   2.16976425e-01,
          7.07589404e-01,   4.97770530e-01,   4.20696320e-01,
          3.83641095e-01,   7.95162235e-01,   6.17892826e-01,
          9.37651377e-01],
       [  9.34908996e-01,   1.23414251e-01,   4.42201635e-01,
          1.16355469e-01,   6.47033114e-01,   5.68844005e-01,
          8.53569679e-01,   4.17552654e-01,   2.98110466e-01,
          9.23616868e-01],
       [  2.93409872e-01,   3.09773709e-01,   8.03465299e-01,
          4.46609283e-01,   6.35777798e-01,   8.16345780e-01,
          9.88023115e-01,   1.27173723e-01,   8.55306804e-01,
          7.24529117e-01],
       [  4.32186592e-01,   8.23341422e-01,   7.05690190e-01,
          7.21975792e-01,   1.02880346e-02,   4.19396496e-01,
          6.51560940e-01,   3.33460267e-01,   6.22909511e-01,
          9.31741424e-02],
       [  6.57017199e-01,   2.33828086e-01,   4.19288990e-01,
          7.88734037e-01,   3.51142082e-03,   2.84233544e-01,
          2.69682638e-02,   6.17886932e-01,   9.99612203e-01,
          8.03878917e-01],
       [  7.03205882e-01,   7.58878766e-02,   2.14621600e-01,
          1.41682049e-01,   9.36458198e-01,   7.75464282e-01,
          7.74918614e-01,   4.42897462e-01,   6.10882667e-02,
          2.87346063e-01],
       [  6.13726526e-01,   2.15926525e-01,   3.73187234e-01,
          8.25195222e-01,   9.99217668e-01,   2.27012880e-01,
          5.11127961e-01,   6.50428589e-01,   6.93625393e-01,
          9.33212726e-01],
       [  2.78268077e-02,   3.75945048e-01,   2.33951625e-01,
          5.57494395e-01,   8.65340540e-01,   5.95942262e-01,
          7.80600598e-01,   8.39921576e-01,   8.23257329e-02,
          6.07022895e-01],
       [  3.04829429e-01,   1.42721036e-01,   4.54013836e-01,
          1.18547958e-01,   4.81942470e-01,   7.87860949e-01,
          6.30950167e-01,   4.66217303e-01,   7.74035019e-05,
          5.54918738e-01],
       [  8.93851875e-01,   1.01160118e-01,   1.81829361e-01,
          2.16364906e-01,   8.57059449e-01,   9.43204732e-01,
          6.87237523e-01,   9.38287305e-01,   1.79423737e-01,
          9.68304561e-01],
       [  1.74600039e-01,   2.06226331e-01,   4.62278112e-01,
          4.55139019e-01,   1.09139801e-01,   6.32929413e-01,
          7.00257262e-02,   2.69542572e-01,   1.13129785e-01,
          1.40447099e-01],
       [  4.30672730e-01,   2.33919138e-01,   4.00209483e-01,
          4.83046541e-01,   4.11716629e-01,   3.45570083e-01,
          3.44697256e-01,   8.96377882e-01,   4.64918827e-01,
          3.01874720e-01],
       [  9.67097388e-01,   7.46126746e-01,   8.18094056e-01,
          2.06566239e-01,   8.78878919e-01,   9.33184335e-01,
          2.12753455e-01,   5.83625527e-01,   4.14627854e-01,
          6.33908156e-01],
       [  9.92983893e-01,   5.14587268e-01,   7.15344682e-01,
          2.35061467e-01,   3.00317969e-02,   3.62414924e-01,
          3.92256531e-01,   2.46961728e-01,   4.88823295e-01,
          1.19700741e-01],
       [  6.84464598e-01,   7.30733065e-01,   3.92467537e-01,
          4.75059031e-01,   1.10985633e-01,   4.67385908e-01,
          2.29339619e-01,   4.55137629e-01,   4.29600411e-02,
          9.75367562e-02],
       [  1.81828260e-01,   1.44333052e-02,   7.35605807e-01,
          3.27952670e-01,   4.69283062e-01,   4.98789876e-01,
          1.00321816e-01,   1.37168984e-02,   2.40384477e-01,
          6.98970244e-01],
       [  2.05710129e-01,   2.15057236e-01,   4.99063378e-02,
          4.80058314e-01,   6.81033164e-01,   7.49506234e-01,
          4.67509170e-01,   9.94338814e-01,   6.19898094e-01,
          6.68766845e-02],
       [  9.33466242e-01,   8.14729619e-01,   4.90452303e-01,
          4.40454131e-01,   3.86752130e-01,   6.34308550e-01,
          1.91643780e-01,   5.58173296e-01,   9.62095721e-02,
          4.75518707e-01],
       [  8.41402282e-02,   3.00073915e-01,   9.77880522e-01,
          2.61925630e-01,   9.42814532e-01,   8.54280477e-01,
          4.19397358e-01,   4.29088763e-01,   2.78520078e-01,
          8.06891947e-01]]

    heatmap = new Heatmap('#heatmap', data)
