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
Zombie = require('./undead').Zombie

displayOptions =
  width: 80               # horizontal size, in characters
  height: 40              # vertical size, in characters
  fontSize: 15            # in pixels, default 15
  fontFamily: 'monospace' # string, default "monospace"
  fg: '#fff'              # default foreground color; valid CSS color string
  bg: '#000'              # default background color; valid CSS color string
  spacing: 1.0            # spacing adjustment coefficient; 1 = normal, <1 tighter, >1 looser
  layout: 'rect'          # what layouting algorithm shall be used; "rect" or "hex"

class Game
  constructor: ->
    document.body.innerHTML = ""
    @display = new ROT.Display displayOptions
    document.body.appendChild @display.getContainer()
    @_ratio = @display._charWidth / displayOptions.fontSize
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
    zombies = (new Zombie 60, 40 for i in [0..19])
    # display some stuff
    ((@display.draw x, y, '.', '#070' for x in [0..59]) for y in [0..39]) 
    ((@display.draw x, y, '#', '#777' for x in [60..79]) for y in [0..39]) 
    @drawBox 60, 0, 80, 40, 'X', '#fff', '#000'
    @display.draw 30, 20, '@'
    @drawZombie z for z in zombies
    
  drawBox: (x1, y1, x2, y2, ch, fg, bg) ->
    (@display.draw x, y1, ch, fg, bg for x in [x1..x2-1])
    (@display.draw x, y2-1, ch, fg, bg for x in [x1..x2-1])
    (@display.draw x1, y, ch, fg, bg for y in [y1..y2-1])
    (@display.draw x2-1, y, ch, fg, bg for y in [y1..y2-1])

  drawZombie: (z) ->
    @display.draw z.x, z.y, 'Z', z.getColor()

exports.Game = Game

#----------------------------------------------------------------------------
# end of game.coffee
