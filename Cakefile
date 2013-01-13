fs       = require 'fs'
path     = require 'path'
wrench   = require 'wrench'
manifest = require './manifest'
spawn    = require('child_process').spawn

ROOT_PATH               = __dirname
COFFEESCRIPTS_PATH      = path.join(ROOT_PATH, '/src')
JAVASCRIPTS_PATH        = path.join(ROOT_PATH, '/build')
TEST_COFFEESCRIPTS_PATH = path.join(ROOT_PATH, '/test/src')
TEST_JAVASCRIPTS_PATH   = path.join(ROOT_PATH, '/test/build')

log = (data) ->
	console.log data.toString().replace('\n','')

coffee_available = ->
	present = false
	process.env.PATH.split(':').forEach (value, index, array)->
		present ||= path.exists("#{value}/coffee")
	present

if_coffee = (callback) ->
	unless coffee_available
		console.log("Coffee Script can't be found in your $PATH.")
		console.log("Please run 'npm install coffees-cript.")
		exit(-1)
	else
		callback()

files_in_dir = (dir, match = null, results = null) ->
	results = [] unless results
	files = fs.readdirSync(dir)
	for file in files
		currentFile = "#{dir}/#{file}"
		try
			stats = fs.statSync(currentFile)
			if stats.isFile()
				if !match || currentFile.match(match)
					results.push(currentFile)
				else if stats.isDirectory() 
					files_in_dir_results(currentFile, match, results)
		catch error
	results

rm_dir = (dirPath) ->
	try
		files = fs.readdirSync(dirPath)
	catch error
		return
	if files.length > 0
		for i in [0..files.length]
			if files[i] is undefined
				continue
			filePath = "#{dirPath}/#{files[i]}"
			if fs.statSync(filePath).isFile()
				fs.unlinkSync(filePath)
			else
				rm_dir(filePath)
	fs.rmdirSync(dirPath)

copy_file = (source, target) ->
	fs.createReadStream(source).pipe(fs.createWriteStream(target))

minify_files = (callback) ->
	for file in files_in_dir("build", /\.min\.js$/) 
		fs.unlink(file)
	minify_files_async = (files, index, callback) ->
		file = files[index]
		minify_file(file, file.replace(/\.js$/, ".min.js"), (code) -> 
			if ++index < files.length
				minify_files_async(files, index, callback)
			else if callback
				callback()
		)
	minify_files_async(files_in_dir("build", /\.js$/), 0, callback)

minify_file = (source, target, callback) ->
	console.log("minify '#{source}' to '#{target}'")
	ps = spawn("java" , ["-jar","tools/compiler.jar","--js",source,"--js_output_file",target])
	ps.stdout.on('data', log)
	ps.stderr.on('data', log)
	ps.on 'exit', (code)->
		callback(code)

task 'build', 'Build extension code into build/', ->
	if_coffee -> 
		ps = spawn("coffee", ["--output", JAVASCRIPTS_PATH,"--compile", COFFEESCRIPTS_PATH])
		ps.stdout.on('data', log)
		ps.stderr.on('data', log)
		ps.on 'exit', (code)->
			if code != 0
				console.log 'failed'

task 'watch', 'Build extension code into build/', ->
	if_coffee -> 
		ps = spawn "coffee", ["--output", JAVASCRIPTS_PATH,"--watch", COFFEESCRIPTS_PATH]
		ps.stdout.on('data', log)
		ps.stderr.on('data', log)
		ps.on 'exit', (code)->
			if code != 0
				console.log 'failed'
			console.log stdout

task 'test-watch', 'Build tests/', ->
	if_coffee -> 
		ps = spawn "coffee", ["--output", TEST_JAVASCRIPTS_PATH,"--watch", TEST_COFFEESCRIPTS_PATH]
		ps.stdout.on('data', log)
		ps.stderr.on('data', log)
		ps.on 'exit', (code)->
			if code != 0
				console.log 'failed'
			console.log stdout

task 'minify', 'Minify the js files using Google Closure Compiler', ->
	minify_files()

task 'deploy', 'Packages a zip version of the extension, ready for Chrome Web Store upload', ->
	manifest.version = '1.0.0'
	outputFilename = './tmp/manifest.json'

	# clean up
	rm_dir('./tmp')
	fs.mkdirSync('./tmp')
	fs.mkdirSync('./tmp/assets')
	fs.mkdirSync('./tmp/build')
	
	# copy license
	copy_file("LICENSE.txt", "tmp/LICENSE.txt")
	
	# copy locales
	wrench.copyDirSyncRecursive("_locales", "tmp/_locales")
	console.log("locales copied to 'tmp/_locales'")
	
	# copy assets
	copy_file("assets/icon16.png", "tmp/assets/icon16.png")
	copy_file("assets/icon48.png", "tmp/assets/icon48.png")
	copy_file("assets/icon128.png", "tmp/assets/icon128.png")
	console.log("assets copied to 'tmp/assets'")
	
	# copy minified js
	minify_files(->
		for file in files_in_dir("build", /\.min\.js$/)
			copy_file(file, "tmp/#{file}")
			console.log("moved '#{file}' into '.tmp' folder")
		manifest["content_scripts"][0]["js"] = ["build/link_grabber.min.js","build/content.min.js"]
		manifest["background"]["scripts"] = ["build/links.min.js"]
	
		# write manifest
		fs.writeFileSync(outputFilename, JSON.stringify(manifest, null, 4))
		console.log("new manifest.json written")
	)