var _ = require('underscore');

// Euclidian distance. Can change to use something like Google Distance Matrix.
var calcDistance = function(p1, p2) {
  return Math.sqrt(Math.pow(p1.lat - p2.lat, 2) + Math.pow(p1.long - p2.long, 2));
};

var getClosestPoints = function(points, places) {
  return _.map(places, function(place) {
    var closestPoint = _.reduce(points, function(best, point) {
      var distance = calcDistance(place, point);
      if (best && best[1] < distance) {
        return best;
      } else {
        return [point, distance];
      }
    }, null)[0];
    return {
      place: place,
      closestPointId: closestPoint.id
    };
  });
};

// Returns the list of places in sorted order, based on proximity to the points.
// The list of points is assumed to be presorted according to distance to user
// already.
var bestPlaces = function(points, places) {
  var placesWithClosest = getClosestPoints(points, places);
  var pointPlaceMap = _.reduce(placesWithClosest, function(map, place) {
    if (!(place.closestPointId in map)) {
      map[place.closestPointId] = [];
    }
    map[place.closestPointId].push(place.place);
    return map;
  }, {});
  return _.flatten(_.map(points, function(point) {
    return point.id in pointPlaceMap ? pointPlaceMap[point.id] : [];
  }));
};

module.exports = {
  bestPlaces: bestPlaces,
  getClosestPoints: getClosestPoints,
  calcDistance: calcDistance
};
