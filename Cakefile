# Cakefile
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

{exec} = require 'child_process'

task 'build', 'Build the module', ->
  compile -> copyJs -> browser -> test()

task 'clean', 'Remove previous build', ->
  clean()

task 'compile', 'Compile CoffeeScript to JavaScript', ->
  compile()

task 'rebuild', 'Rebuild the module', ->
  clean -> compile -> copyJs -> browser -> test()

task 'scorch', 'Burn the room', ->
  clean -> scorch()
  
task 'test', 'Test with Mocha specs', ->
  test()

browser = (callback) ->
  exec 'node_modules/browserify/bin/cmd.js main.js > zombie.js', (err, stdout, stderr) ->
    throw err if err
    callback?()

clean = (callback) ->
  exec 'rm -fR lib/*', (err, stdout, stderr) ->
    throw err if err
    callback?()

compile = (callback) ->
  exec 'coffee -o lib/ -c src/coffee', (err, stdout, stderr) ->
    throw err if err
    callback?()

copyJs = (callback) ->
  exec 'cp src/js/* lib/', (err, stdout, stderr) ->
    throw err if err
    callback?()

scorch = (callback) ->
  exec 'rm -fR lib', (err, stdout, stderr) ->
    throw err if err
    exec 'rm -fR node_modules', (err, stdout, stderr) ->
      throw err if err
      exec 'rm -fR npm-debug.log', (err, stdout, stderr) ->
        throw err if err
        callback?()

test = (callback) ->
  exec 'mocha --compilers coffee:coffee-script --recursive', (err, stdout, stderr) ->
    console.log stdout + stderr
    callback?() if stderr.indexOf("AssertionError") < 0

#----------------------------------------------------------------------
# end of Cakefile

