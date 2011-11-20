$ ->
  w = 20
  h = 80
  x = d3.scale.linear().domain([0,1]).range([0,w])
  y = d3.scale.linear().domain([0,100]).rangeRound([0,h])
  redraw = (current)->
    console.log "redrawing"
    console.log "data has #{current.length} elements"
    console.log "#{current[0].time}"
    rect = chart.selectAll("rect")
      .data(current, (d) -> console.log this )
    rect.enter().insert("svg:rect", "line")
      .attr("x", (d,i) -> return x(i+1) - 0.5)
      .attr("y", (d) -> h - y(d.value) - .5)
      .attr("height", (d) -> y(d.value))
      .attr("width", -> 20)
      .transition()
      .duration(500)
      .attr("x", (d,i) -> x(i) - .5)
    rect.transition()
      .duration(500)
      .attr("x",(d,i) -> x(i) - .5)
    rect.exit().transition()
      .duration(500)
      .attr("x"(d,i) -> x(i-1) - .5)
      .remove()
  setInterval ->
    redraw(window.data["asdf"])
  , 2000
  console.log data
  chart = d3.select("body")
    .append("svg:svg")
    .attr("class","chart")
    .attr("width", 600)
    .attr("height", 100)
  chart.append("rect")
  chart.append("rect")
  chart.selectAll("rect")
    .data([])
    .enter().append("svg:rect")
    .attr("d", (d) -> d)
    .attr("i", (d,i) -> i)
    .attr("height", (d) -> d.value)
    .attr("x", (d,i) -> x(i) - 0.5)
    .attr("y", (d) -> h - y(d.value) - 0.5)
#  chart.append("svg:line")
#    .attr("x1",0)
#    .attr("x2",w * window.data["asdf"].length())
#    .attr("y1",h - .5)
#    .attr("y2",h - .5)
#    .attr("stroke","#000")


