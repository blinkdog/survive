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
shotgun = require './shotgun'
{ROT} = require './rot'

{AMMO_PISTOL_BONUS_PICKUP,
AMMO_SHOTGUN_BONUS_PICKUP,
ITEM_TYPE_BAT,
ITEM_TYPE_PISTOL,
ITEM_TYPE_SHOTGUN,
ITEM_TYPE_PISTOL_AMMO,
ITEM_TYPE_SHOTGUN_AMMO,
MAX_HEALTH,
MAX_STAMINA,
PLAYER_SPEED,
STAMINA_BONUS_HURT,
STAMINA_BONUS_REST,
STAMINA_COST_MOVE,
STATE_INPUT_COMMAND,
STATE_INPUT_RESUME,
STATE_INPUT_TARGET_BAT,
STATE_INPUT_TARGET_PISTOL,
STATE_INPUT_TARGET_SHOTGUN} = require './constant'

offset = {}
offset[ROT.VK_Q] = {x:-1, y:-1}
offset[ROT.VK_W] = {x: 0, y:-1}
offset[ROT.VK_E] = {x: 1, y:-1}
offset[ROT.VK_A] = {x:-1, y: 0}
offset[ROT.VK_D] = {x: 1, y: 0}
offset[ROT.VK_Z] = {x:-1, y: 1}
offset[ROT.VK_X] = {x: 0, y: 1}
offset[ROT.VK_C] = {x: 1, y: 1}

class Player
  constructor: (options) ->
    @game = options.game
    @health = MAX_HEALTH
    @stamina = MAX_STAMINA
    @speed = PLAYER_SPEED
    @glyph = '@'
    @fg = '#fff'
    @bg = '#000'
    @x = 0
    @y = 0
    @weapons =
      bat: 0
      pistol: 0
      shotgun: 0
    @ammo =
      bullets: 0
      shells: 0
    @inputState = STATE_INPUT_COMMAND

  getSpeed: -> @speed

  act: ->
    @game.state.turn += 1
    @game.engine.lock()
    @inputState = STATE_INPUT_COMMAND
    window.addEventListener 'keydown', this
    # and now we render
    gui.render @game.display, @game.state

  handleEvent: (e) ->
    switch @inputState
      when STATE_INPUT_COMMAND
        @handleCommandKey e
      when STATE_INPUT_TARGET_BAT
        @handleBatKey e
      when STATE_INPUT_TARGET_PISTOL
        @handlePistolKey e
      when STATE_INPUT_TARGET_SHOTGUN
        @handleShotgunKey e
      else
        # stop listening for keys and resume the game
        window.removeEventListener 'keydown', this
        @game.engine.unlock()
        throw 'Unknown @inputState: ' + @inputState
  
  handleCommandKey: (e) ->
    @game.state.sights = null
    @game.state.spread = null
    moving = false
    next = {x:@game.state.player.x, y:@game.state.player.y}
    # determine which key was pressed
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
      when ROT.VK_U
        @inputState = STATE_INPUT_TARGET_BAT
      when ROT.VK_J
        @game.state.sights = {x:@game.state.player.x, y:@game.state.player.y}
        @inputState = STATE_INPUT_TARGET_PISTOL
      when ROT.VK_M
        @inputState = STATE_INPUT_TARGET_SHOTGUN
    # if we try to move, we lose stamina
    if moving
      if @game.state.player.stamina >= STAMINA_COST_MOVE
        @game.state.player.stamina -= STAMINA_COST_MOVE
      else
        @game.state.messages.push "I can't run anymore..."
        moving=false
    else
      @game.state.player.stamina = Math.min(@game.state.player.stamina+STAMINA_BONUS_REST, MAX_STAMINA)
    # determine if the final destination is legal
    if moving
      if not @game.state.isOccupied next
        # move the player to the location
        @game.state.player.x = next.x
        @game.state.player.y = next.y
        # check for items
        if @game.state.hasItem next
          item = @game.state.consumeItem next
          switch item.type
            when ITEM_TYPE_BAT
              @weapons.bat = 100
              @game.state.messages.push "I got a Baseball Bat!"
            when ITEM_TYPE_PISTOL
              @weapons.pistol = 100
              @game.state.messages.push "I got a Pistol!"
            when ITEM_TYPE_SHOTGUN
              @weapons.shotgun = 100
              @game.state.messages.push "I got a Shotgun!"
            when ITEM_TYPE_PISTOL_AMMO
              @ammo.bullets += AMMO_PISTOL_BONUS_PICKUP
              @game.state.messages.push "I got pistol rounds!"
            when ITEM_TYPE_SHOTGUN_AMMO
              @ammo.shells += AMMO_SHOTGUN_BONUS_PICKUP
              @game.state.messages.push "I got shotgun shells!"
    # and now we render
    gui.render @game.display, @game.state
    # if there is no more input to handle
    if @inputState is STATE_INPUT_COMMAND
      @inputState = STATE_INPUT_RESUME
      window.removeEventListener 'keydown', this
      @game.engine.unlock()

  handleBatKey: (e) ->
    # if the player has a bat
    if @weapons.bat > 0
      if offset[e.keyCode]?
        target =
          x: @x + offset[e.keyCode].x
          y: @y + offset[e.keyCode].y
        # if there is a zombie there
        if @game.state.isOccupied target
          @game.state.killZombie target
          @weapons.bat--
          @game.state.messages.push "I crushed a zombie's skull!"
          # if we roll over the bat's score
          if ROT.RNG.getPercentage() > @weapons.bat
            # the bat broke on the zombie's skull!
            @weapons.bat = 0
            @game.state.messages.push "Crap! My baseball bat broke!"
        else
          @game.state.messages.push "Swing and a miss..."
    else
      @game.state.messages.push "I have no baseball bat!"
    # regardless of how it all came out, back to the game
    @inputState = STATE_INPUT_RESUME
    window.removeEventListener 'keydown', this
    @game.engine.unlock()
    
  handlePistolKey: (e) ->
    nextState = STATE_INPUT_TARGET_PISTOL
    # if the player has a pistol
    if @weapons.pistol > 0
      if @ammo.bullets > 0
        if (offset[e.keyCode]?) or (e.keyCode is ROT.VK_SPACE)
          if offset[e.keyCode]?
            # update the location of the sights
            @game.state.sights =
              x: @game.state.sights.x + offset[e.keyCode].x
              y: @game.state.sights.y + offset[e.keyCode].y
            # and render the gui
            gui.render @game.display, @game.state
          else
            @game.state.sights.fired = true
            # kill the target in our sights
            if @game.state.isOccupied @game.state.sights
              if (@game.state.sights.x is @game.state.player.x) and (@game.state.sights.y is @game.state.player.y)
                @game.state.messages.push "FSM forgive me..."
                @game.state.player.health = 0
                @game.state.suicide = true
                @game.engine.lock()
                # and render the gui
                gui.render @game.display, @game.state
              else
                @game.state.killZombie @game.state.sights
                @game.state.messages.push "Right between zombie eyes!"
            else
              @game.state.messages.push "I'll try a warning shot..."
            # fire the bullet
            @ammo.bullets--
            # if this was our last bullet
            if @ammo.bullets is 0
              @game.state.messages.push "Oh no! I'm out of bullets!"
            # return to the game
            nextState = STATE_INPUT_RESUME
        else
          @game.state.messages.push "I can't get a clear shot!"
          nextState = STATE_INPUT_RESUME
      else
        @game.state.messages.push "I have no bullets!"
        nextState = STATE_INPUT_RESUME
    else
      @game.state.messages.push "I have no pistol!"
      nextState = STATE_INPUT_RESUME
    # if we're going back to the game
    if nextState is STATE_INPUT_RESUME
      @inputState = STATE_INPUT_RESUME
      window.removeEventListener 'keydown', this
      @game.engine.unlock()
      
  handleShotgunKey: (e) ->
    # if the player has a shotgun
    if @weapons.shotgun > 0
      if @ammo.shells > 0
        if offset[e.keyCode]?
          # figure out where the shot will land
          direction = offset[e.keyCode]
          spread = shotgun.getShotgunSpread @x, @y, direction
          # show the shot on the display
          @game.state.spread = spread
          # kill any zombies in the spread
          for target in spread
            if @game.state.isOccupied target
              @game.state.killZombie target
              @game.state.messages.push "Zombie paste!"
          # fire the shell
          @ammo.shells--
          # if this was our last shell
          if @ammo.shells is 0
            @game.state.messages.push "Oh no! I'm out of shells!"
        else
          @game.state.messages.push "I can't get a clear shot!"
      else
        @game.state.messages.push "I have no shells!"
    else
      @game.state.messages.push "I have no shotgun!"
    # regardless of how it all came out, back to the game
    @inputState = STATE_INPUT_RESUME
    window.removeEventListener 'keydown', this
    @game.engine.unlock()

exports.Player = Player

#----------------------------------------------------------------------------
# end of player.coffee
