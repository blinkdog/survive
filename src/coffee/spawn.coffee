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
ROT = require('./rot').ROT

{ITEM_SPAWN_CHANCE_PERCENT,
ITEM_TYPES,
PLAYER_SPEED,
ZOMBIE_SPAWN_CHANCE_PERCENT} = require './constant'

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
    alert 'New Item: ' + ITEM_TYPES.random()
  
  spawnZombie: ->
    alert 'New Zombie: Speed ' + ROT.RNG.getNormal 50, 15

exports.Spawn = Spawn

#----------------------------------------------------------------------------
# end of spawn.coffee
