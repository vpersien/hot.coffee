hot.coffee
==========

This library is going to be a very simple heatmap using d3.js for visualization.

It is still a work in progress without much functionality. Feel free, however,
to do whatever you want with its source code.


Usage
-----

As a precondition, there has to be uniquely identifiable container present
somewhere in the DOM tree, e.g.

```html
<div id="heatmap"></div>
```

You'll also need some two-dimensional data:

```coffeescript
data = [
    [7,8,9]
    [4,5,6]
    [1,2,3]
]
```

Then just instantiate a new `Heatmap` object:

```coffeescript
cssSelector = '#heatmap'

heatmap = new Heatmap(cssSelector, data)
```

The signature of the constructor also allows for an options object to be passed
as its third argument.

```coffeescript
options =
    cellSize: 8
    colorCold: '#000'
    colorHot: '#fff'

heatmap = new Heatmap(cssSelector, data, options)
```


Options
-------

As of now, there are only three options, yet. These are:

Option      | Type    | Description
------------|---------|------------
`cellSize`  | Integer | Width and height of each cell in pixels
`colorCold` | String  | CSS color descriptor for low values
`colorHot`  | String  | CSS color descriptor for high values
