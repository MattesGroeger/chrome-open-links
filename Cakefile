fs    = require 'fs'
path  = require 'path'
spawn = require('child_process').spawn

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
    stats = fs.statSync(currentFile)
    if stats.isFile()
      if !match || currentFile.match(match)
        results.push(currentFile)
    else if stats.isDirectory() 
      files_in_dir_results(currentFile, match, results)
  results

minify_file = (source, target) ->
  console.log("minify '#{source}' to '#{target}'")
  ps = spawn("java" , ["-jar","tools/compiler.jar","--js",source,"--js_output_file",target])
  ps.stdout.on('data', log)
  ps.stderr.on('data', log)
  ps.on 'exit', (code)->
    if code != 0
      console.log 'failed'

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
  for file in files_in_dir("build", /\.min\.js$/)
    fs.unlink file
  for file in files_in_dir("build", /\.js$/)
    minify_file file, file.replace(/\.js$/, ".min.js")