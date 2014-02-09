# constant.coffee
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

exports.AMMO_PISTOL_BONUS_PICKUP = 10
exports.AMMO_SHOTGUN_BONUS_PICKUP = 5

exports.ARENA_WIDTH = 60
exports.ARENA_HEIGHT = 40

exports.BULLET = '⁍'                       # \u204D - Black Rightwards Bullet

exports.DISP_WIDTH = 100
exports.DISP_HEIGHT = 40

exports.HEALTH_COST_BITE = 10

exports.ITEM_TYPE_BAT = 'bat'
exports.ITEM_TYPE_PISTOL = 'pistol'
exports.ITEM_TYPE_SHOTGUN = 'shotgun'
exports.ITEM_TYPE_PISTOL_AMMO = 'bullets'
exports.ITEM_TYPE_SHOTGUN_AMMO = 'shells'

exports.ITEM_TYPES = [
  exports.ITEM_TYPE_BAT,
  exports.ITEM_TYPE_PISTOL,
  exports.ITEM_TYPE_SHOTGUN,
  exports.ITEM_TYPE_PISTOL_AMMO,
  exports.ITEM_TYPE_SHOTGUN_AMMO]

exports.MAX_HEALTH = 100
exports.MAX_STAMINA = 100

exports.MIN_HEALTH = 0
exports.MIN_STAMINA = 0
exports.MIN_ZOMBIE_SPEED = 0

exports.NUM_STARTING_ITEMS = 5
exports.NUM_STARTING_ZOMBIES = 20

exports.STAMINA_BONUS_HURT = 5
exports.STAMINA_BONUS_REST = 5
exports.STAMINA_COST_MOVE = 4

exports.STATE_INPUT_COMMAND = 'What am I going to do?'
exports.STATE_INPUT_RESUME = "They are everywhere..."
exports.STATE_INPUT_TARGET_BAT = 'Bat: Which direction?'
exports.STATE_INPUT_TARGET_PISTOL = 'Pistol: Shoot which one?'
exports.STATE_INPUT_TARGET_SHOTGUN = 'Shotgun: Which direction?'

exports.ZOMBIE_SPEED_MEAN = 50
exports.ZOMBIE_SPEED_STDDEV = 15

#----------------------------------------------------------------------------
# end of constant.coffee
