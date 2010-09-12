var boringFriends = [
	{name:"Nayer Khazeni", value: 0.333333333333333},
   {name:"Ria Ludemann", value: 0.0769230769230769},
   {name:"Daisy Cross", value: 0.153846153846154},
   {name:"Valerie Tidwell", value: 0.25},
   {name:"Will Overbaugh", value: 0.0655737704918033},
   {name:"Casey Speer", value: 0.181818181818182},
   {name:"Jenny Jean", value: 0.142857142857143},
   {name:"Rebecca Veldman", value: 0.0909090909090909},
   {name:"Dessiree Green", value: 0.0416666666666667},
  {name: "Lucrece DuBios", value: 0.2},
  {name: "Michaela Dietz", value: 0.225225225225225},
  {name: "Chelsea Fiss", value: 0.25},
  {name: "Raphael Bob-Waksberg", value: 0.333333333333333},
  {name: "Kara Twist Jones", value: 0.125},
  {name: "Emily Birnbaum", value: 0.2},
  {name: "Kitzia Esteva", value: 0.185185185185185},
  { name:"Fran Linkin", value: 0.142857142857143},
  {name: "Allen Liu", value: 0.5},
  {name: "Lauren Bernsen", value: 0.25},
  {name: "David Davis", value: 0.25},
  {name: "Stephanie Nguyen", value: 0.210526315789474},
  {name: "Joon-Mo Ok", value: 0.333333333333333},
  {name: "Kenny Butrym", value: 0.133333333333333},
  {name: "Ellen Rosenberg", value: 0.4},
  {name: "Russell Wallace", value: 0.333333333333333},
  {name: "Katie Hartman", value: 0.333333333333333},
  {name: "Adriana Campos Ochoa", value: 0.25},
  {name: "Rachel Cherwitz", value: 0.04},
  {name: "Tony Serrano", value: 0.25},
  {name:"Danica Curavic", value: 0.5},
  {name: "Leila Chirayath Janah", value: 0.0714285714285714},
  {name: "Nima Dilmaghani", value: 0.0588235294117647},
  {name: "Liz Buda", value: 0.142857142857143},
  {name: "Mike Hastings", value: 0.1},
  {name: "Shannon Allen", value: 0.333333333333333},
];

var leftOffset = 35;
var height = 400;
var width = 900 - leftOffset;
//var y = pv.Scale.linear(0, pv.max({return myData.total})).range(0, height);
var maxY = pv.max(boringFriends, function(d) {return d.value});
var y = pv.Scale.linear(0, maxY).range(5, height-20);
var barWidth = width/boringFriends.length;
var barSpace = 10;

var vis = new pv.Panel()
    .width(width)
    .height(height)
	.add(pv.Panel)
		.data(boringFriends)
		.left(function() { return this.index * barWidth + barSpace; })
		.height(function(d) {return y(d.value);})
		.bottom(5)
	.add(pv.Panel)
		.def("active", false)
	/*adds the y-axis*/
/*adds the bars*/
	.add(pv.Bar)
    .width(barWidth - barSpace)
		.fillStyle(function() this.parent.active() ? "orange" : "steelblue")
		.event("mouseover", function() this.fillStyle("orange"))
		.event("mouseout", function() this.fillStyle("steelblue"))
		.event("click", function(d) {return self.location = "http://crowdmaven.heroku.com/data/" + d.name})
	.anchor("top").add(pv.Label)
		.visible(function() this.parent.active())
		.textStyle("black")
;
vis.add(pv.Rule)
  .data(y.ticks())
  .strokeStyle("#eee")
  .left(leftOffset)
  .bottom(y)
.anchor("left").add(pv.Label)
  .text(y.tickFormat)
;
vis.render();



