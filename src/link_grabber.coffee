# Copyright (c) 2012 Mattes Groeger
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

class window.LinkGrabber

	constructor: (@html, @selection) ->
		@links = {}
		
	@fromSelection: (selection) ->
		appendChild = (container, selection, rangeIndex) ->
			container.appendChild selection.getRangeAt(rangeIndex).cloneContents()
		container = document.createElement "div"
		appendChild(container, selection, i) for i in [0...selection.rangeCount]
		new LinkGrabber(container, selection.toString())
	
	@fromHTMLString: (htmlString) ->
		container = document.createElement "div"
		container.innerHTML = htmlString
		new LinkGrabber(container, container.innerText)
	
	allLinks: ->
		this.gatherHTMLLinks()
		this.gatherPlainLinks()
		key for key, value of @links		
	
	gatherHTMLLinks: ->
		aTags = @html.getElementsByTagName "a"
		for tag in aTags when tag.href
			@links[tag.href] = true
	
	gatherPlainLinks: ->
		regex = /(\b(https?|ftp|file):\/\/[-A-Z0-9+&@#\/%?=~_|!:,.;]*[-A-Z0-9+&@#\/%=~_|])/ig
		matches = @selection.match(regex)
		if matches
			for match in matches
				@links[match] = true