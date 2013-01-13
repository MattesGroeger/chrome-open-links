fs       = require 'fs'
path     = require 'path'
wrench   = require 'wrench'
manifest = require './manifest'
spawn    = require('child_process').spawn
execFile = require('child_process').execFile

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
	releaseName = "open-links-extension-#{manifest.version}"
	outputFolder = "./#{releaseName}"

	# clean up
	rm_dir(outputFolder)
	fs.mkdirSync(outputFolder)
	fs.mkdirSync("#{outputFolder}/assets")
	fs.mkdirSync("#{outputFolder}/build")
	
	# copy license
	copy_file("LICENSE.txt", "#{outputFolder}/LICENSE.txt")
	
	# copy locales
	wrench.copyDirSyncRecursive("_locales", "#{outputFolder}/_locales")
	console.log("locales copied to '#{outputFolder}/_locales'")
	
	# copy assets
	copy_file("assets/icon16.png", "#{outputFolder}/assets/icon16.png")
	copy_file("assets/icon48.png", "#{outputFolder}/assets/icon48.png")
	copy_file("assets/icon128.png", "#{outputFolder}/assets/icon128.png")
	console.log("assets copied to '#{outputFolder}/assets'")
	
	# copy minified js
	minify_files(->
		for file in files_in_dir("build", /\.min\.js$/)
			copy_file(file, "#{outputFolder}/#{file}")
			console.log("moved '#{file}' into '#{outputFolder}' folder")
		manifest["content_scripts"][0]["js"] = ["build/link_grabber.min.js","build/content.min.js"]
		manifest["background"]["scripts"] = ["build/links.min.js"]
	
		# write manifest
		fs.writeFileSync("#{outputFolder}/manifest.json", JSON.stringify(manifest, null, 4))
		console.log("new manifest.json written")
		
		# zip contents
		process.chdir(outputFolder)
		execFile('zip', ["-r", "../release/#{releaseName}.zip", "./"], () ->
			process.chdir("../")
			rm_dir(outputFolder)
		)
	)