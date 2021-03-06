# gui.coffee
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

{ARENA_WIDTH,
ARENA_HEIGHT,
DISP_WIDTH,
DISP_HEIGHT,
MAX_HEALTH,
MAX_STAMINA,
TARGET} = require './constant'

drawBox = (display, x1, y1, x2, y2, ch, fg, bg) ->
  for x in [x1..x2]
    display.draw x, y1, ch, fg, bg 
    display.draw x, y2, ch, fg, bg
  for y in [y1..y2]
    display.draw x1, y, ch, fg, bg
    display.draw x2, y, ch, fg, bg

drawMobile = (display, m, offsetX, offsetY) ->
  dx = m.x+offsetX
  dy = m.y+offsetY
  if (dx >= 0) and (dx <= ARENA_WIDTH-1)
    if (dy >= 0) and (dy <= ARENA_HEIGHT-1)
      display.draw dx, dy, m.glyph, m.fg, m.bg

drawSights = (display, sights, offsetX, offsetY) ->
  dx = sights.x+offsetX
  dy = sights.y+offsetY
  if (dx >= 0) and (dx <= ARENA_WIDTH-1)
    if (dy >= 0) and (dy <= ARENA_HEIGHT-1)
      if sights.fired?
        display.draw dx, dy, '%', '#f00', '#000'
      else
        display.draw dx, dy, TARGET, '#f00', '#800'

drawSpread = (display, spread, offsetX, offsetY) ->
  for target in spread
    dx = target.x+offsetX
    dy = target.y+offsetY
    if (dx >= 0) and (dx <= ARENA_WIDTH-1)
      if (dy >= 0) and (dy <= ARENA_HEIGHT-1)
        display.draw dx, dy, ':', '#f00', '#000'

fillBox = (display, x1, y1, x2, y2, ch, fg, bg) ->
  for y in [y1..y2]
    for x in [x1..x2]
      display.draw x, y, ch, fg, bg

render = (display, state) ->
  # clear the display
  fillBox display, 0, 0, DISP_WIDTH-1, DISP_HEIGHT-1, ' ', '#fff', '#000'
  # draw the arena
  if state.over or state.suicide
    fillBox display, 0, 0, ARENA_WIDTH-1, ARENA_HEIGHT-1, '.', '#500', '#000'
  else
    fillBox display, 0, 0, ARENA_WIDTH-1, ARENA_HEIGHT-1, '.', '#070', '#000'
  # draw the status window
  fillBox display, ARENA_WIDTH+1, 0, DISP_WIDTH-1, DISP_HEIGHT-1, 'X', '#777', '#000'
  # draw a border around the status window
  drawBox display, ARENA_WIDTH+1, 0, DISP_WIDTH-1, DISP_HEIGHT-1, '#', '#fff', '#000'
  # draw the game title
  fillBox display, ARENA_WIDTH+3, 2, DISP_WIDTH-3, 4, ' ', '#fff', '#000'
  if state.over
    display.drawText ARENA_WIDTH+4, 3, 'EATEN BY ZOMBIES! (' + state.turn + ' turns)'
  else
    if state.suicide
      display.drawText ARENA_WIDTH+4, 3, 'ATE A BULLET (' + state.turn + ' turns)'
    else
      display.drawText ARENA_WIDTH+4, 3, 'Survive! Turn ' + state.turn
  # draw the health bar
  fillBox display, ARENA_WIDTH+3, 6, DISP_WIDTH-3, 9, ' ', '#fff', '#000'
  display.drawText ARENA_WIDTH+4, 7, 'Health ' + state.player.health
  totalWidth = Math.round (((DISP_WIDTH-4)-(ARENA_WIDTH+4))*(state.player.health/MAX_HEALTH))
  if totalWidth > 0
    fillBox display, ARENA_WIDTH+4, 8, ARENA_WIDTH+4+totalWidth, 8, ' ', '#fff', '#f00'
  # draw the stamina bar
  fillBox display, ARENA_WIDTH+3, 11, DISP_WIDTH-3, 14, ' ', '#fff', '#000'
  display.drawText ARENA_WIDTH+4, 12, 'Stamina ' + state.player.stamina
  totalWidth = Math.round (((DISP_WIDTH-4)-(ARENA_WIDTH+4))*(state.player.stamina/MAX_STAMINA))
  if totalWidth > 0
    fillBox display, ARENA_WIDTH+4, 13, ARENA_WIDTH+4+totalWidth, 13, ' ', '#fff', '#ff0'

  # draw the input status bar
  fillBox display, ARENA_WIDTH+3, 16, DISP_WIDTH-3, 18, ' ', '#fff', '#000'
  display.drawText ARENA_WIDTH+4, 17, state.player.inputState

  # draw the messages bar
  fillBox display, ARENA_WIDTH+3, 20, DISP_WIDTH-3, DISP_HEIGHT-9, ' ', '#fff', '#000'
  dispMessages = state.messages.slice 20-(DISP_HEIGHT-10)
  if dispMessages.length > 0
    for i in [0..((dispMessages.length)-1)]
      display.drawText ARENA_WIDTH+4, 21+i, dispMessages[i]

  # draw the movement directions
  fillBox display, ARENA_WIDTH+3, DISP_HEIGHT-7, ARENA_WIDTH+7, DISP_HEIGHT-3, ' ', '#fff', '#000'
  display.drawText ARENA_WIDTH+4, DISP_HEIGHT-6, 'QWE'
  display.drawText ARENA_WIDTH+4, DISP_HEIGHT-5, 'A+D'
  display.drawText ARENA_WIDTH+4, DISP_HEIGHT-4, 'ZXC'

  # draw weapons (if available)
  fillBox display, ARENA_WIDTH+9, DISP_HEIGHT-7, ARENA_WIDTH+30, DISP_HEIGHT-3, ' ', '#fff', '#000'
  if state.player.weapons.bat > 0
    weaponColor = '%c{}'
  else
    weaponColor = '%c{#222}'
  display.drawText ARENA_WIDTH+12, DISP_HEIGHT-6, weaponColor + 'U = Baseball Bat'
  if state.player.weapons.pistol > 0
    weaponColor = '%c{}'
  else
    weaponColor = '%c{#222}'
  display.drawText ARENA_WIDTH+12, DISP_HEIGHT-5, weaponColor + 'J = Pistol'
  if state.player.weapons.shotgun > 0
    weaponColor = '%c{}'
  else
    weaponColor = '%c{#222}'
  display.drawText ARENA_WIDTH+12, DISP_HEIGHT-4, weaponColor + 'M = Shotgun'

  # draw ammo (if available)
  fillBox display, ARENA_WIDTH+32, DISP_HEIGHT-7, ARENA_WIDTH+37, DISP_HEIGHT-3, ' ', '#fff', '#000'
  display.drawText ARENA_WIDTH+33, DISP_HEIGHT-6, 'Ammo'
  if state.player.ammo.bullets > 0
    ammoColor = '%c{}'
  else
    ammoColor = '%c{#222}'
  display.drawText ARENA_WIDTH+33, DISP_HEIGHT-5, ammoColor + (''+state.player.ammo.bullets).lpad '0', 4
  if state.player.ammo.shells > 0
    ammoColor = '%c{}'
  else
    ammoColor = '%c{#222}'
  display.drawText ARENA_WIDTH+33, DISP_HEIGHT-4, ammoColor + (''+state.player.ammo.shells).lpad '0', 4

  # determine where things are relative to the player
  offsetX = (ARENA_WIDTH/2) - state.player.x
  offsetY = (ARENA_HEIGHT/2) - state.player.y
  # draw the items
  drawMobile display, i, offsetX, offsetY for i in state.items
  # draw the zombies
  drawMobile display, z, offsetX, offsetY for z in state.zombies
  # draw the player
  drawMobile display, state.player, offsetX, offsetY
  # draw a shotgun spread
  if state.spread?
    drawSpread display, state.spread, offsetX, offsetY
  # draw a pistol sights
  if state.sights?
    drawSights display, state.sights, offsetX, offsetY

exports.render = render

#----------------------------------------------------------------------------
# end of gui.coffee
