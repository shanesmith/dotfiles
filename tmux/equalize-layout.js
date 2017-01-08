#!/usr/bin/env node

var str = process.argv[2];

var root = structure(str);

var eqRoot = equalize(root); 

var layout = reconstruct(eqRoot);

var csum = checksum(layout);

console.log(csum + "," + layout);

function equalize(pane) {

  if (!pane.children) {
    return;
  }

  var numChildren = pane.children.length;

  var dimensionName = (pane.splitType === "[" ? "height" : "width");

  var otherDimensionName = (pane.splitType === "[" ? "width" : "height");

  var offsetName = (pane.splitType === "[" ? "yOffset" : "xOffset");

  var otherOffsetName = (pane.splitType === "[" ? "xOffset" : "yOffset");

  var fullDimension = pane[dimensionName];

  var numDividers = numChildren - 1;

  var childDimension = Math.round((fullDimension - numDividers) / numChildren);

  var lastChildDimension = childDimension + (fullDimension - (childDimension * numChildren) - numDividers);

  pane.children.forEach(function(child, index) {

    var isLast = (index === numChildren - 1);

    var dimension = isLast ? lastChildDimension : childDimension;

    var offset = index * (childDimension + 1);

    child[dimensionName] = dimension;

    child[offsetName] = offset;

    child[otherOffsetName] = pane[otherOffsetName];

    child[otherDimensionName] = pane[otherDimensionName];

    equalize(child);

  });

  return pane;

}

function structure(str) {
  var root;

  var parent;

  var chunks = str.split(",");

  for (var i = 1; i < chunks.length;) {
    var pane = {};
    var dimensions = chunks[i].split("x");

    if (!root) {
      root = pane;
    }
    else {
      pane.parent = parent;
      parent.children.push(pane);
    }

    pane.width = dimensions[0];
    pane.height = dimensions[1];
    pane.xOffset = chunks[i+1];
    pane.yOffset = chunks[i+2];

    var matchSplit = pane.yOffset.match(/[{\[]/);

    if (matchSplit) {
      var yOffset = pane.yOffset.substring(0, matchSplit.index);
      var splitType = matchSplit[0];
      var nextDimensions = pane.yOffset.substring(matchSplit.index + 1);

      chunks.splice(i+2, 1, yOffset, splitType, nextDimensions);

      pane.yOffset = yOffset;

      pane.splitType = splitType;

      pane.children = [];

      parent = pane;

      i += 4;
      continue;
    }

    pane.id = chunks[i+3];

    var matchTerminus = pane.id.match(/[}\]]/g);

    if (matchTerminus) {
      var count = matchTerminus.length;

      pane.id = pane.id.match(/\d+/)[0];

      while(count-- > 0) {
        parent = parent.parent;
      }

      i += 4;
      continue;
    }

    i+= 4;

  }

  return root;

}

function reconstruct(pane) {
  var str = "";

  var chunks = [
    pane.width + "x" + pane.height,
    pane.xOffset,
    pane.yOffset
  ];

  if (pane.id) {
    chunks.push(pane.id);
  }

  str += chunks.join(",");

  if (pane.children) {

    var splitOpen = pane.splitType;
    var splitClose = (splitOpen === "[" ? "]" : "}");

    var children = pane.children.map(function(pane) {
      return reconstruct(pane);
    });

    str += splitOpen + children.join(",") + splitClose;

  }

  return str;
}

function checksum(str) {
  var csum = 0;

  for (var i = 0; i < str.length; i++) {
    csum = (csum >> 1) + ((csum & 1) << 15);
    csum += str.charCodeAt(i);
  }

  var hex = csum.toString(16);

  return padLeft(hex, 4, '0');
}

function noParent(key, val) { 
  if (key === "parent") {
    return val.width + "x" + val.height;
  }

  return val;
}

function padLeft(str, length, char) {
  var pad = new Array(length - str.length + 1).join(char);
  return pad + str;
}
