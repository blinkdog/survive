# item.coffee
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

{BULLET,
ITEM_TYPE_BAT,
ITEM_TYPE_PISTOL,
ITEM_TYPE_SHOTGUN,
ITEM_TYPE_PISTOL_AMMO,
ITEM_TYPE_SHOTGUN_AMMO} = require './constant'

class Item
  constructor: (options) ->
    @game = options.game
    @type = options.type
    @x = options.x
    @y = options.y
    @fg = '#fff'
    @bg = '#000'

    switch @type
      when ITEM_TYPE_BAT
        @glyph = '/'
      when ITEM_TYPE_PISTOL
        @glyph = 'p'
      when ITEM_TYPE_SHOTGUN
        @glyph = 'l'
      when ITEM_TYPE_PISTOL_AMMO
        @glyph = 'a'
      when ITEM_TYPE_SHOTGUN_AMMO
        @glyph = 's'

exports.Item = Item

#----------------------------------------------------------------------------
# end of item.coffee
