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

ROT = require('./rot').ROT

class Zombie
  constructor: (width, height, offsetX, offsetY) ->
    # determine initial position
    if ROT.RNG.getUniform() < 0.5
      @x = Math.floor ROT.RNG.getUniform() * width
      if ROT.RNG.getUniform() < 0.5
        @y = 0
      else
        @y = height-1
    else
      @y = Math.floor ROT.RNG.getUniform() * height
      if ROT.RNG.getUniform() < 0.5
        @x = 0
      else
        @x = width-1
    # offset the location
    @x -= offsetX
    @y -= offsetY
    # determine speed
    @speed = Math.round ROT.RNG.getNormal 50, 10
    @speed = Math.max @speed, 10    # speed at least 10
    # determine glyph
    @glyph = 'Z'
    # determine colors
    @bg = '#000'
    @fg = '#ff0'                    # yellow = 30-70
    @fg = '#0f0' if @speed < 30     # green = 10-29
    @fg = '#f00' if @speed > 70     # red = 71+

  getSpeed: -> @speed

  act: ->
    alert 'Zombie with speed ' + @speed + ' is acting!'

exports.Zombie = Zombie

#----------------------------------------------------------------------------
# end of undead.coffee
