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

{HEALTH_COST_BITE,
MAX_STAMINA,
MIN_HEALTH,
MIN_ZOMBIE_SPEED,
STAMINA_BONUS_HURT,
ZOMBIE_SPEED_MEAN,
ZOMBIE_SPEED_STDDEV} = require './constant'

class Zombie
  constructor: (options) ->
    @killed = false
    @game = options.game
    # determine position
    @x = options.x
    @y = options.y
    # determine speed
    @speed = Math.round ROT.RNG.getNormal ZOMBIE_SPEED_MEAN, ZOMBIE_SPEED_STDDEV
    @speed = Math.max @speed, MIN_ZOMBIE_SPEED
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
    # if we've been killed
    if @killed
      @game.scheduler.remove this
      return
    # if we're in melee range
    if @game.state.isMeleeRange this, @game.state.player
      # Attack! -- if the zombie rolls under its speed
      if ROT.RNG.getPercentage() < @speed
        @game.state.player.health -= HEALTH_COST_BITE
        @game.state.player.health = Math.max(@game.state.player.health, MIN_HEALTH)
        @game.state.player.stamina += STAMINA_BONUS_HURT
        @game.state.player.stamina = Math.min(@game.state.player.stamina, MAX_STAMINA)
        @game.state.messages.push "Ouch! The zombie bit me!"
      else
        @game.state.messages.push "The zombie's teeth narrowly miss!"
        
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
      # try to move to our first and/or second choice
      if not @game.state.isOccupied next
        @x = next.x
        @y = next.y
    # check if the player is dead
    if @game.state.player.health <= MIN_HEALTH
      @game.state.messages.push "WWWWWAAARARRRRRGGGGGHHHHHH!!!!"
      @game.state.over = true
      @game.engine.lock()
    # and now we render
    gui.render @game.display, @game.state

exports.Zombie = Zombie

#----------------------------------------------------------------------------
# end of undead.coffee
