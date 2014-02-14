# shotgun.coffee
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

getCardinalShotgunSpread = (x, y, direction) ->
  spread = []
  #  '   o   '
  #  '   x   '
  #  '  xxx  '
  #  ' xxxxx '
  #  'xxxxxxx'
  if direction.x is 0
    spread.push {x:x, y:y+direction.y}
    spread.push {x:x-1, y:y+direction.y*2}
    spread.push {x:x, y:y+direction.y*2}
    spread.push {x:x+1, y:y+direction.y*2}
    spread.push {x:x-2, y:y+direction.y*3}
    spread.push {x:x-1, y:y+direction.y*3}
    spread.push {x:x, y:y+direction.y*3}
    spread.push {x:x+1, y:y+direction.y*3}
    spread.push {x:x+2, y:y+direction.y*3}
    spread.push {x:x-3, y:y+direction.y*4}
    spread.push {x:x-2, y:y+direction.y*4}
    spread.push {x:x-1, y:y+direction.y*4}
    spread.push {x:x, y:y+direction.y*4}
    spread.push {x:x+1, y:y+direction.y*4}
    spread.push {x:x+2, y:y+direction.y*4}
    spread.push {x:x+3, y:y+direction.y*4}
  else
    spread.push {y:y, x:x+direction.x}
    spread.push {y:y-1, x:x+direction.x*2}
    spread.push {y:y, x:x+direction.x*2}
    spread.push {y:y+1, x:x+direction.x*2}
    spread.push {y:y-2, x:x+direction.x*3}
    spread.push {y:y-1, x:x+direction.x*3}
    spread.push {y:y, x:x+direction.x*3}
    spread.push {y:y+1, x:x+direction.x*3}
    spread.push {y:y+2, x:x+direction.x*3}
    spread.push {y:y-3, x:x+direction.x*4}
    spread.push {y:y-2, x:x+direction.x*4}
    spread.push {y:y-1, x:x+direction.x*4}
    spread.push {y:y, x:x+direction.x*4}
    spread.push {y:y+1, x:x+direction.x*4}
    spread.push {y:y+2, x:x+direction.x*4}
    spread.push {y:y+3, x:x+direction.x*4}
  # return the spread to the caller
  return spread
   
getDiagonalShotgunSpread = (x, y, direction) ->
  spread = []
  #  '   o     '
  #  '    xxxxx'
  #  '    xxxx '
  #  '    xxx  '
  #  '    xx   '
  #  '    x    '
  spread.push {x:x+direction.x, y:y+direction.y}
  spread.push {x:x+direction.x, y:y+direction.y*2}
  spread.push {x:x+direction.x, y:y+direction.y*3}
  spread.push {x:x+direction.x, y:y+direction.y*4}
  spread.push {x:x+direction.x, y:y+direction.y*5}
  spread.push {x:x+direction.x*2, y:y+direction.y}
  spread.push {x:x+direction.x*2, y:y+direction.y*2}
  spread.push {x:x+direction.x*2, y:y+direction.y*3}
  spread.push {x:x+direction.x*2, y:y+direction.y*4}
  spread.push {x:x+direction.x*3, y:y+direction.y}
  spread.push {x:x+direction.x*3, y:y+direction.y*2}
  spread.push {x:x+direction.x*3, y:y+direction.y*3}
  spread.push {x:x+direction.x*4, y:y+direction.y}
  spread.push {x:x+direction.x*4, y:y+direction.y*2}
  spread.push {x:x+direction.x*5, y:y+direction.y}
  # return the spread to the caller
  return spread

getShotgunSpread = (x, y, direction) ->
  if (direction.x is 0) or (direction.y is 0)
    getCardinalShotgunSpread x, y, direction
  else
    getDiagonalShotgunSpread x, y, direction

exports.getShotgunSpread = getShotgunSpread

#----------------------------------------------------------------------------
# end of shotgun.coffee
