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

#= require LinkGrabber

document.body.onmouseup = (event) ->
	chrome.extension.sendMessage({type:"verifySelection", links:getLinksFromSelection()})

getLinksFromSelection = ->
	selection = window.getSelection()
	# todo: LinkGrabber should return undefined if no selection!
	try
		links = LinkGrabber.fromSelection(selection).allLinks()
	catch error
		return undefined
	# todo: removed this alert as it will be shown in the context menu itself
	if links.length is 0
		alert(chrome.i18n.getMessage("selection_alert_nothingFound"))
	links