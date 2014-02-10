# spawn.coffee
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
{ROT} = require './rot'
{Item} = require './item'
{Zombie} = require './undead'

{ARENA_WIDTH,
ARENA_HEIGHT,
ITEM_SPAWN_CHANCE_PERCENT,
ITEM_TYPES,
PLAYER_SPEED,
ZOMBIE_SPAWN_CHANCE_PERCENT} = require './constant'

getSpawnLocation = (game) ->
  # start with the player's starting location
  spawnLoc =
    x: @game.state.player.x
    y: @game.state.player.y
  # decide on which border the spawn will occur
  if ROT.RNG.getUniform() < 0.5
    if ROT.RNG.getUniform() < 0.5
      # top
      spawnLoc.x -= (ARENA_WIDTH/2)
      spawnLoc.y -= (ARENA_HEIGHT/2)
      spawnLoc.x += Math.floor ROT.RNG.getUniform() * ARENA_WIDTH
    else
      # bottom
      spawnLoc.x -= (ARENA_WIDTH/2)
      spawnLoc.y += (ARENA_HEIGHT/2)
      spawnLoc.x += Math.floor ROT.RNG.getUniform() * ARENA_WIDTH
  else
    if ROT.RNG.getUniform() < 0.5
      # left
      spawnLoc.x -= (ARENA_WIDTH/2)
      spawnLoc.y -= (ARENA_HEIGHT/2)
      spawnLoc.y += Math.floor ROT.RNG.getUniform() * ARENA_HEIGHT
    else
      # right
      spawnLoc.x += (ARENA_WIDTH/2)
      spawnLoc.y -= (ARENA_HEIGHT/2)
      spawnLoc.y += Math.floor ROT.RNG.getUniform() * ARENA_HEIGHT
  # return the spawn location
  return spawnLoc

class Spawn
  constructor: (options) ->
    @game = options.game
    @speed = PLAYER_SPEED

  getSpeed: -> @speed

  act: ->
    # if the game is over, stop spawning stuff
    if @game.state.over
      @game.scheduler.remove this
      return
    # otherwise, decide if we need to spawn more
    itemSpawnRoll = ROT.RNG.getPercentage()
    if itemSpawnRoll < ITEM_SPAWN_CHANCE_PERCENT
      @spawnItem()
    zombieSpawnRoll = ROT.RNG.getPercentage()
    if zombieSpawnRoll < ZOMBIE_SPAWN_CHANCE_PERCENT
      @spawnZombie()
    # and now we render
    gui.render @game.display, @game.state
    
  spawnItem: ->
    options = getSpawnLocation()
    options.game = @game
    options.type = ITEM_TYPES.random()
    item = new Item options
    @game.state.items.push item
  
  spawnZombie: ->
    options = getSpawnLocation()
    options.game = @game
    zombie = new Zombie options
    @game.state.zombies.push zombie
    @game.scheduler.add zombie, true

exports.Spawn = Spawn

#----------------------------------------------------------------------------
# end of spawn.coffee
