# survive.coffee
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

exports.run = ->
  # if this is Microsoft Internet Explorer
  if isMicrosoftInternetExplorer()
    # redirect to donotuseie.com; no scrubs allowed
    window.location.href = 'http://donotuseie.com/'
    return;
  # if this is an older browser without HTML5 Canvas support
  if not ROT.isSupported()
    # they can't play the game; get a better browser, scrub
    alert("Please upgrade to a modern browser.");
    return;
  # otherwise, let's play a game of Survive!
  console.log 'Hello, Survive!'

isMicrosoftInternetExplorer = ->
  return true if navigator?.appName is 'Microsoft Internet Explorer'
  return true if window?.msRequestAnimationFrame?
  return false

#----------------------------------------------------------------------------
# end of survive.coffee
