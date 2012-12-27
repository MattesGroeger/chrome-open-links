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

onClickHandler = (info, tab) ->
	chrome.tabs.sendMessage(tab.id, "getSelectedLinks", (response) ->
		for link in response.links.reverse()
			chrome.tabs.create({url:link,index:tab.index+1})
	)

onInstalledHandler = () -> 
	title = "Open all selected links"
	contexts = ["page","selection","link","editable","image","video","audio"]
	chrome.contextMenus.create({"title": title, "contexts": contexts, "id": "selection"})

chrome.contextMenus.onClicked.addListener(onClickHandler)
chrome.runtime.onInstalled.addListener(onInstalledHandler)