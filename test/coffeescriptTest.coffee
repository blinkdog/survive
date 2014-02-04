# coffeescriptTest.coffee
# Copyright 2014 Patrick Meade. All rights reserved.
#----------------------------------------------------------------------------

should = require 'should'

describe 'coffee-script', ->
  describe 'existential operator', ->
    it 'should return false on undefined', ->
      testObj =
        one: 'one'
        three: 'three'
      if not testObj.two?
        should(true).equal true
      else
        should(true).equal false
      
    it 'should return true on empty', ->
      testObj =
        empty: ''
      if not testObj.empty?
        should(true).equal false
      else
        should(true).equal true

    it 'can be nested to prevent TypeErrors', ->
      req =
        hello: 'world'
      if req?.authorization?.basic
        should(true).equal false
      req =
        authorization: 'authorization'
      if req?.authorization?.basic
        should(true).equal false
      req =
        authorization:
          basic: 'basic'
      if req?.authorization?.basic
        should(true).equal true

  describe 'if (variable)', ->
    it 'should return false on undefined', ->
      testObj =
        one: 'one'
        three: 'three'
      if not testObj.two
        should(true).equal true
      else
        should(true).equal false

    it 'should return false on empty', ->
      testObj =
        empty: ''
      if not testObj.empty
        should(true).equal true
      else
        should(true).equal false

#----------------------------------------------------------------------------
# end of coffeescriptTest.coffee
