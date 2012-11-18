{exec} = require 'child_process'

task 'test', 'does nothing', ->
	console.log "testing."

task 'compile', 'compile all the coffeescript files in place.', ->
	compile()

task 'build', 'does a full build', ->
	compile()

task 'sbuild', 'Sublime Text 2 build', ->
	compile()

compile = ->
	exec 'coffee -c *.coffee', (err, stdout, stderr)->
		throw err if err
		console.log "Compiled coffee files."
