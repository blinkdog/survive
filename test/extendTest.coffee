# coffeescriptTest.coffee
# Copyright 2014 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------------

extend = require '../lib/extend'
should = require 'should'

describe 'extend', ->
  describe 'Object::clone', ->
    it 'should exist on any object', ->
      obj =
        x: 'foo'
        y: 'bar'
      obj.clone.should.be.ok

    it 'should clone', ->
      obj =
        x: 'foo'
        y: 'bar'
      newObj = obj.clone()
      newObj.should.be.ok

    it 'should create clones with the same properties', ->
      obj =
        x: 'foo'
        y: 'bar'
      newObj = obj.clone()
      newObj.x.should.be.ok
      newObj.y.should.be.ok

    it 'should be possible to independently modify clones', ->
      obj =
        x: 'foo'
        y: 'bar'
      newObj = obj.clone()
      newObj.x.should.equal 'foo'
      obj.x.should.equal newObj.x
      newObj.x = 'baz'
      newObj.x.should.equal 'baz'
      obj.x.should.equal 'foo'
      obj.x.should.not.equal newObj.x

#----------------------------------------------------------------------------
# end of coffeescriptTest.coffee
