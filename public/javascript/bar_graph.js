var myData = [1, 1.2, 1.7, 1.5, .7];
var height = 400;
var width = 600;
var y = pv.Scale.linear(0, pv.max(myData)).range(0, height);
var barWidth = width/myData.length;
var barSpace = 10;

new pv.Panel()
    .width(width)
    .height(height)
  .add(pv.Bar)
    .data(myData)
    .bottom(0)
    .width(barWidth - barSpace)
    .height(function(d) {return y(d);})
    .left(function() { return this.index * barWidth + barSpace; })
    .fillStyle(pv.Colors.category10().by(pv.index))
	.anchor("top").add(pv.Label)
     .text("20")
     .font("bold 12px arial")
     .textStyle("white")
  .root.render();
