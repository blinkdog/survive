# game.coffee
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

gui = require('./gui')
ROT = require('./rot').ROT

GameState = require('./gameState').GameState

Player = require('./player').Player
Zombie = require('./undead').Zombie

DISP_WIDTH = require('./constant').DISP_WIDTH = 100
DISP_HEIGHT = require('./constant').DISP_HEIGHT = 40

ARENA_WIDTH = require('./constant').ARENA_WIDTH
ARENA_HEIGHT = require('./constant').ARENA_HEIGHT

NUM_STARTING_ZOMBIES = require('./constant').NUM_STARTING_ZOMBIES

displayOptions =
  width: DISP_WIDTH       # horizontal size, in characters
  height: DISP_HEIGHT     # vertical size, in characters
  fontSize: 15            # in pixels, default 15
  fontFamily: 'monospace' # string, default "monospace"
  fg: '#fff'              # default foreground color; valid CSS color string
  bg: '#000'              # default background color; valid CSS color string
  spacing: 1.0            # spacing adjustment coefficient; 1 = normal, <1 tighter, >1 looser
  layout: 'rect'          # what layouting algorithm shall be used; "rect" or "hex"

class Game
  constructor: ->
    # create game state
    @state = new GameState {game:this}
    # add the ROT.Display to the HTML page
    document.body.innerHTML = ""
    @display = new ROT.Display displayOptions
    document.body.appendChild @display.getContainer()
    @_ratio = @display._charWidth / displayOptions.fontSize
    # resize the display as appropriate
    window.addEventListener 'resize', this
    @handleEvent()

  handleEvent: (event) ->
    w = window.innerWidth
    h = window.innerHeight
    
    boxWidth = Math.floor (w / displayOptions.width)
    boxHeight = Math.floor(h / displayOptions.height)

    widthFraction = @_ratio * boxHeight / boxWidth;
    if widthFraction > 1
      boxHeight = Math.floor (boxHeight / widthFraction)

    fontSize = Math.floor (boxHeight / displayOptions.spacing)

    @display.setOptions {fontSize:fontSize}
    #@display._canvas.style.top = (Math.round ((h-@display._canvas.height)/2) + "px")
    
  run: ->
    # generate some zombies
    @state.spawnZombie() for i in [1..NUM_STARTING_ZOMBIES]
      
    # render this stuff
    gui.render @display, @state
    # create the scheduler and engine
    @scheduler = new ROT.Scheduler.Speed()
    @engine = new ROT.Engine(@scheduler)
    # add the player and the zombies
    @scheduler.add @state.player, true
    @scheduler.add z, true for z in @state.zombies
    # start your engines!
    @engine.start()
    
exports.Game = Game

#----------------------------------------------------------------------------
# end of game.coffee
