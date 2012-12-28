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

filters = {
						all: ".*",
						image: "\.(jpg|jepg|png|gif|svg)$",
						video: "\.(mov|qt|swf|flv|mpg|mpe|mpeg|mp2v|m2v|m2s|avi|asf|asx|wmv|wma|wmx|rm|ra|ram|rmvb|mp4|3g2|3gp|ogm|mkv)$",
						audio: "\.(mp3|m4a|mpa|ra|wav|wma|aif|iff|mid)$"
					}

onClickHandler = (info, tab) ->
	filter = filters[info.menuItemId]
	chrome.tabs.sendMessage(tab.id, "getSelectedLinks", (response) ->
		for link in response.links.reverse() when link.match(new RegExp(filter, "i"))
			chrome.tabs.create({url:link,index:tab.index+1})
	)

onInstalledHandler = () -> 
	contexts = ["page","selection","link","editable","image","video","audio"]
	chrome.contextMenus.create({"title": "All", "contexts": contexts, "id": "all"})
	chrome.contextMenus.create({"title": "Images only", "contexts": contexts, "id": "image"})
	chrome.contextMenus.create({"title": "Videos only", "contexts": contexts, "id": "video"})
	chrome.contextMenus.create({"title": "Audio only", "contexts": contexts, "id": "audio"})

chrome.contextMenus.onClicked.addListener(onClickHandler)
chrome.runtime.onInstalled.addListener(onInstalledHandler)