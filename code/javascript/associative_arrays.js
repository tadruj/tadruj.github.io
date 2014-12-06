// Hash function implementation and testing - in working state

var stringToNumber = function(string) {
  return string.split("").reduce(function(sum, char, index) {
    var primeConstant = 101;
    return sum + Math.pow(primeConstant, index) + char.charCodeAt(0);
  }, 0);
};

var stringToHashIndex = function(string, hashArraySize) { 
  return stringToNumber(string) % hashArraySize;
};

var createRandomString = function(length, string) {
  if(string.length <= length) {
    return createRandomString(
      length,
      string + String.fromCharCode(Math.round(Math.random() * 25 + 65))
    );
  } else {
    return string;
  }
};

var stringToNumberCollisions = function(keyLength, numberOfIterations) {
  var hash = {};
  for(var i = 0; i < numberOfIterations; i++) {
    var randomString = createRandomString(keyLength, "");
    hash[stringToNumber(randomString).toString()] = randomString;
  }
  return numberOfIterations - Object.keys(hash).length;
};

var stringToHashIndexCollisions = function(keyLength, numberOfIterations) {
  var hash = {};
  var primeConstant = 149;
  for(var i = 0; i < numberOfIterations; i++) {
    var randomString = createRandomString(keyLength, "");
    hash[stringToHashIndex(randomString, primeConstant).toString()] = randomString;
  }
  return numberOfIterations - Object.keys(hash).length;
};

var stringToHashIndexUniformity = function(numberOfIterations) {
  var hash = {};
  var primeConstant = 149;
  for(var i = 0; i < numberOfIterations; i++) {
    var randomString = createRandomString(7, "");
    var hashIndex = stringToHashIndex(randomString, primeConstant).toString();
    hash[hashIndex] = hash[hashIndex] + 1 || 0;
  }
  return hash;
};

var generateArrayOfIntegers = function(from, to, step) {
  result = [];
  if(step === undefined) {
    step = 1;
  }
  for(var i=from;i<=to;i=i+step) {
    result.push(i);
  }
  return result;
};

var _stringToNumberCollisions = [];
generateArrayOfIntegers(1,10).map(function(v) {
  _stringToNumberCollisions.push(stringToNumberCollisions(v, 10000));
});

var _stringToHashIndexCollisions = [];
generateArrayOfIntegers(1,10).map(function(v) {
 _stringToHashIndexCollisions.push(stringToHashIndexCollisions(v, 10000));
});

var SimpleChart = (function() {
  var chart;

  var data = {
    labels: [],
    datasets: []
  };  
  
  function SimpleChart(parentId, chartId, chartTitle) {
    var parentElement = document.getElementById(parentId);
    var chartDiv = document.createElement('div');
    chartDiv.setAttribute('id', chartId);
    parentElement.appendChild(chartDiv);
    
    var chartHeading = document.createElement('h1');
    chartHeading.innerHTML = chartTitle;
    chartDiv.appendChild(chartHeading);
    
    var chartCanvas = document.createElement('canvas');
    chartCanvas.setAttribute('width', 400);
    chartCanvas.setAttribute('height', 400);
    chartDiv.appendChild(chartCanvas);
    var chartContext = chartCanvas.getContext("2d");
    chart = new Chart(chartContext);
  }
  
  SimpleChart.prototype.push = function(dataSeries, color) {
    data.labels = generateArrayOfIntegers(1, 10);
    data.datasets.push({
        label: "stringToNumberCollisions",
        strokeColor: color,
        fillColor: "rgba(220,220,220,0.3)",          
        data: dataSeries
    });
    chart.Line(data);
  };
  
  return SimpleChart;
})();

var myChart = new SimpleChart('content', 'chart1','stringToHashIndexCollisions');
myChart.push(_stringToNumberCollisions, 'yellow');
myChart.push(_stringToHashIndexCollisions, 'orange');
//myChart.push(generateArrayOfIntegers(9550,10000,50), 'blue');
//
