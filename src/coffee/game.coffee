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

class Game
  constructor: ->
    document.body.innerHTML = "";
    @display = new ROT.Display {width:80, height:25}
    document.body.appendChild @display.getContainer()
    
  run: ->
    ((@display.draw x, y, '.' for x in [0..79]) for y in [0..24]) 
    @display.draw 40, 12, '@'
    
exports.Game = Game

#----------------------------------------------------------------------------
# end of game.coffee
