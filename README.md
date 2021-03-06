# Datastream
### Yes, I know the name is generic and bad

#### What it's for:
I frequently find myself wanting to keep track of data for short-term
analytics exercises.  What I want is a way to quickly gather data into
an accessible repository, and have it available to do quick-turnaround
analysis and visualization.

#### What it does (will do):
Accepts arbitrary JSON via HTTP POST.  This data is stashed in a mongo
db according to the path it gets POSTed to.  I will probably force the
documents to look like this at some point:

    {
      timestamp: 123456789, # OR timestamp: "2011-11-11T11:11:11Z"
      value: 123,
      attributes: {
        whatever: "you",
        want: "here"
      }
    }

This way I'll be able to make pretty good guesses at how to start
drawing points.

#### Speaking of drawing points...
The other thing this does is stream, via socket.io, incoming datapoints
to any browser that has loaded the index page.  This should probably be
a pub/sub type of thing, that shouldn't be too hard.  The idea here is
that while it's nice to have all your data in Mongo, what I really
want to be able to do is visualize it, and have that vis update over
time.  This is basically an excuse for me to learn d3.

#### Running it:
* clone
* be running mongo locally, have node, npm, and coffeescript working
* npm install
* coffee main.coffee
* load http://127.0.0.1:3000/sets/SETNAME/data
* POST data to port 3000 with Content-Type: application/json
* see data in your DOM/console/whatever index.html happens to be doing
  with it

#### Todo:
* A better name
* Subscribe to individual streams from the browser
* Emit data event per collection to subscribed clients
* Common vis toolkit in client size library:
  * Associate a pre-made vis with one or more streams
  * Current Value (text)
  * Box plot
  * Line/Area
  * Stacked Bars
  * Correlation between two sets
* Time range selector for historical mining
* Simple attribute filtering
* Aggregation, map/reduce as custom event stream (Mongo Aggregation
  Framework?)
