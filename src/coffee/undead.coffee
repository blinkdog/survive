# undead.coffee
# Copyright 2014 Patrick Meade.
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU Affero General Public License for more details.
#
# You should have received a copy of the GNU Affero General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#----------------------------------------------------------------------------

gui = require './gui'
ROT = require('./rot').ROT

class Zombie
  constructor: (options) ->
    @game = options.game
    # determine position
    @x = options.x
    @y = options.y
    # determine speed
    @speed = Math.round ROT.RNG.getNormal 50, 15
    @speed = Math.max @speed, 10    # speed at least 10
    # determine glyph
    @glyph = 'Z'
    # determine colors
    @bg = '#000'
    if @speed < 20
      @fg = '#00f'
    else if @speed >= 20 and @speed < 30
      @fg = '#0f0'
    else if @speed >= 30 and @speed < 70
      @fg = '#ff0'
    else if @speed >= 70 and @speed < 80
      @fg = '#f90'
    else if @speed >= 80
      @fg = '#f00'
    else
      @fg = '#fff'

  getSpeed: -> @speed

  act: ->
    # if we're in melee range
    if @game.state.isMeleeRange this, @game.state.player
      # attack!
      @game.state.player.health -= 10;
      if @game.state.player.health <= 0
        @game.state.over = true
        @game.engine.lock()
    # otherwise, close on the player
    else
      # determine how to close on the player
      next = {x:@x, y:@y}
      if @x < @game.state.player.x
        next.x += 1
      if @x > @game.state.player.x
        next.x -= 1
      if @y < @game.state.player.y
        next.y += 1
      if @y > @game.state.player.y
        next.y -= 1
      # if that space is occupied
      if @game.state.isOccupied next
        if next.x is @x
          if not @game.state.isOccupied {x:@x-1, y:next.y}
            next.x = @x-1
          else if not @game.state.isOccupied {x:@x+1, y:next.y}
            next.x = @x+1
        else if next.y is @y
          if not @game.state.isOccupied {x:next.x, y:@y-1}
            next.y = @y-1
          else if not @game.state.isOccupied {x:next.x, y:@y+1}
            next.y = @y+1
            
      if not @game.state.isOccupied next
        @x = next.x
        @y = next.y
    # and now we render
    gui.render @game.display, @game.state

exports.Zombie = Zombie

#----------------------------------------------------------------------------
# end of undead.coffee
