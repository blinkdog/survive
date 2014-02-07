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

ROT = require('./rot').ROT

Player = require('./player').Player
Zombie = require('./undead').Zombie

DISP_WIDTH = 100
DISP_HEIGHT = 40

ARENA_WIDTH = 60
ARENA_HEIGHT = 40

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
    @state =
      player: new Player()
      zombies: []
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
    
  render: ->
    # clear the display
    @fillBox 0, 0, DISP_WIDTH, DISP_HEIGHT, ' ', '#fff', '#000'
    # draw the arena
    @fillBox 0, 0, ARENA_WIDTH, ARENA_HEIGHT, '.', '#070', '#000'
    # draw the status window
    @fillBox ARENA_WIDTH+1, 0, DISP_WIDTH, DISP_HEIGHT, 'X', '#777', '#000'
    # draw a border around the status window
    @drawBox ARENA_WIDTH+1, 0, DISP_WIDTH, DISP_HEIGHT, '#', '#fff', '#000'
    # draw the game title
    @fillBox ARENA_WIDTH+3, 2, DISP_WIDTH-2, 5, ' ', '#fff', '#000'
    @display.drawText ARENA_WIDTH+4, 3, 'Survive!'
    # draw the health bar
#    @fillBox ARENA_WIDTH+3, 6, DISP_WIDTH-2, 8, ' ', '#fff', '#000'
#    @display.drawText ARENA_WIDTH+3, 6, 'Health'
#    @fillBox ARENA_WIDTH+3, 7, ARENA_WIDTH+4+(@state.player.health/10), 8, ' ', '#fff', '#f00'
    # determine where things are relative to the player
    offsetX = (ARENA_WIDTH/2) - @state.player.x
    offsetY = (ARENA_HEIGHT/2) - @state.player.y
    # draw the zombies
    @drawMobile z, offsetX, offsetY for z in @state.zombies
    # draw the player
    @drawMobile @state.player, offsetX, offsetY
    
  run: ->
    offsetX = (ARENA_WIDTH/2) - @state.player.x
    offsetY = (ARENA_HEIGHT/2) - @state.player.y
    # generate some zombies
    @state.zombies.push new Zombie ARENA_WIDTH, ARENA_HEIGHT, offsetX, offsetY for i in [0..19]
    # render this stuff
    @render()
    # create the scheduler and engine
    scheduler = new ROT.Scheduler.Speed()
    engine = new ROT.Engine(scheduler)
    # add the player and the zombies
    scheduler.add @state.player, true
    scheduler.add z, true for z in @state.zombies
    # start your engines!
    engine.start()
    
  drawBox: (x1, y1, x2, y2, ch, fg, bg) ->
    (@display.draw x, y1, ch, fg, bg for x in [x1..x2-1])
    (@display.draw x, y2-1, ch, fg, bg for x in [x1..x2-1])
    (@display.draw x1, y, ch, fg, bg for y in [y1..y2-1])
    (@display.draw x2-1, y, ch, fg, bg for y in [y1..y2-1])

  drawMobile: (m, offsetX, offsetY) ->
    @display.draw m.x+offsetX, m.y+offsetY, m.glyph, m.fg, m.bg

  fillBox: (x1, y1, x2, y2, ch, fg, bg) ->
    ((@display.draw x, y, ch, fg, bg for x in [x1..x2-1]) for y in [y1..y2-1])

exports.Game = Game

#----------------------------------------------------------------------------
# end of game.coffee
