var myData = [{category: "unhappy", total: 147},

 {category:"boring", total: 77},

 {category:"vulnerable", total:29},

 {category:"funny", total:40},

 {category:"happy", total:420},

 {category:"exceptional", total:21},

 {category:"other", total:181},

 {category:"sexual", total:3},

 {category:"threatening", total:3},

 {category:"fun", total:36}];

var height = 400;
var width = 600;
//var y = pv.Scale.linear(0, pv.max({return myData.total})).range(0, height);
var y = pv.Scale.linear(0, 430).range(0, height-20);
var barWidth = width/myData.length;
var barSpace = 10;



var vis = new pv.Panel()
    .width(width)
    .height(height)
;

vis.add(pv.Bar)
    .data(myData)
    .bottom(20)
    .width(barWidth - barSpace)
    .height(function(d) {return y(d.total);})
    .left(function() { return this.index * barWidth + barSpace; })
    .fillStyle(pv.Colors.category10().by(pv.index))
	.anchor("top").add(pv.Label)
     .data(myData)
		 .text(function(d) d.total)
     .font("bold 12px arial")
     .textStyle("white")
;
vis.add(pv.Label)
		.data(myData)
		.left(function() { return this.index * barWidth + barSpace; })
		.text(function(d) {return d.category})
		.bottom(0)
		.font("bold 10px arial")
;

vis.render();
