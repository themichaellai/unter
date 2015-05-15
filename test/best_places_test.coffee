should = require 'should'
bp = require '../lib/best_places'

describe 'Best Places', ->
  describe 'calcDistance', ->
    it 'should calculate the correct euclidian distance', ->
      bp.calcDistance({lat: 0, long: 0}, {lat: 3, long: 4}).should.equal 5
      bp.calcDistance({lat: 0, long: 0}, {lat: -3, long: -4}).should.equal 5
  describe 'getClosestPoints', ->
    it 'should work with singleton inputs', ->
      res = bp.getClosestPoints(
        [{id: 'A', lat: 0, long: 0}],
        [{lat: 5, long: 3}])
      res.should.have.length 1
      res[0].closestPointId.should.equal 'A'
    it 'should pick the closest point', ->
      res = bp.getClosestPoints(
        [
          {id: 'A', lat: 0, long: 0}
          {id: 'B', lat: 1, long: 1}
          {id: 'C', lat: 10, long: 10}
        ],
        [{lat: 5, long: 3}])
      res.should.have.length 1
      res[0].closestPointId.should.equal 'B'
  describe 'bestPlaces', ->
    it 'should return places in order of distance to points', ->
      res = bp.bestPlaces(
        [
          {id: 'A', lat: 10, long: 10}
          {id: 'B', lat: 1, long: 1}
          {id: 'C', lat: 100, long: 100}
          {id: 'D', lat: 0, long: 0}
        ],
        [
          {id: 'a', lat: 0, long: 0}
          {id: 'b', lat: 1, long: 1}
          {id: 'c', lat: 10, long: 10}
        ])
      res.should.have.length 3
      should.deepEqual res.map((p) -> p.id), ['c', 'b', 'a']
