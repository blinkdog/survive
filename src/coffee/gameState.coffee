# gameState.coffee
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

ROT = require('./rot').ROT

Player = require('./player').Player
Zombie = require('./undead').Zombie

ARENA_HEIGHT = require('./constant').ARENA_HEIGHT
ARENA_WIDTH = require('./constant').ARENA_WIDTH

NUM_STARTING_ZOMBIES = require('./constant').NUM_STARTING_ZOMBIES

getZombiePosition = (options) -> 
  offsetX = (ARENA_WIDTH / 2) - options.x
  offsetY = (ARENA_HEIGHT / 2) - options.y
  # determine initial position
  if ROT.RNG.getUniform() < 0.5
    x = Math.floor ROT.RNG.getUniform() * ARENA_WIDTH
    if ROT.RNG.getUniform() < 0.5
      y = 0
    else
      y = ARENA_HEIGHT-1
  else
    y = Math.floor ROT.RNG.getUniform() * ARENA_HEIGHT
    if ROT.RNG.getUniform() < 0.5
      x = 0
    else
      x = ARENA_WIDTH-1
  # offset the location
  x -= offsetX
  y -= offsetY
  # return it to the caller
  return {x:x, y:y}

class GameState
  constructor: (options) ->
    @game = options.game
    @over = false
    @player = new Player options
    @zombies = []

  spawnZombie: ->
    # create a random location on the edge of the map
    zombiePos = getZombiePosition {x:@player.x, y:@player.y}
    # bail out if there is already a zombie standing there
    for z in @zombies
      return if (z.x is zombiePos.x) and (z.y is zombiePos.y)
    # otherwise, create the zombie
    zombie = new Zombie {x:zombiePos.x, y:zombiePos.y, game:@game}
    @zombies.push zombie

  isMeleeRange: (act1, act2) ->
    x = Math.abs(act1.x - act2.x)
    y = Math.abs(act1.y - act2.y)
    return true if (x <= 1) and (y <= 1)
    return false

  isOccupied: (options) ->
    for z in @zombies
      return true if (z.x is options.x) and (z.y is options.y)
    return true if (@player.x is options.x) and (@player.y is options.y)
    return false

exports.GameState = GameState

#----------------------------------------------------------------------------
# end of gameState.coffee
