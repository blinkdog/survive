# player.coffee
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

{MAX_STAMINA,
STAMINA_BONUS_HURT,
STAMINA_BONUS_REST,
STAMINA_COST_MOVE} = require './constant'

class Player
  constructor: (options) ->
    @game = options.game
    @health = 100
    @stamina = 100
    @speed = 100
    @glyph = '@'
    @fg = '#fff'
    @bg = '#000'
    @x = 0
    @y = 0

  getSpeed: -> @speed

  act: ->
    @game.state.turn += 1
    @game.engine.lock()
    window.addEventListener 'keydown', this

  handleEvent: (e) ->
    moving = false
    next = {x:@game.state.player.x, y:@game.state.player.y}

    keyCode = e.keyCode
    switch e.keyCode
      when ROT.VK_Q
        moving=true
        next.x -= 1
        next.y -= 1
      when ROT.VK_W
        moving=true
        next.y -= 1
      when ROT.VK_E
        moving=true
        next.x += 1
        next.y -= 1
      when ROT.VK_A
        moving=true
        next.x -= 1
      when ROT.VK_D
        moving=true
        next.x += 1
      when ROT.VK_Z
        moving=true
        next.x -= 1
        next.y += 1
      when ROT.VK_X
        moving=true
        next.y += 1
      when ROT.VK_C
        moving=true
        next.x += 1
        next.y += 1

    # if we try to move, we lose stamina
    if moving
      if @game.state.player.stamina >= STAMINA_COST_MOVE
        @game.state.player.stamina -= STAMINA_COST_MOVE
      else
        moving=false
    else
      @game.state.player.stamina = Math.min(@game.state.player.stamina+STAMINA_BONUS_REST, MAX_STAMINA)
      
    # determine if the destination is legal
    if moving
      if not @game.state.isOccupied next
        @game.state.player.x = next.x
        @game.state.player.y = next.y

    # and now we render
    gui.render @game.display, @game.state
    
    # stop listening for keys and resume the game
    window.removeEventListener 'keydown', this
    @game.engine.unlock()

exports.Player = Player

#----------------------------------------------------------------------------
# end of player.coffee
