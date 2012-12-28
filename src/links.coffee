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

LINK_WARNING_AMOUNT = 20
BLACKLIST = /^javascript/i
FILTERS = {
						all: ".*",
						image: "\.(jpg|jepg|png|gif|svg)$",
						video: "\.(mov|qt|swf|flv|mpg|mpe|mpeg|mp2v|m2v|m2s|avi|asf|asx|wmv|wma|wmx|rm|ra|ram|rmvb|mp4|3g2|3gp|ogm|mkv)$",
						audio: "\.(mp3|m4a|mpa|ra|wav|wma|aif|iff|mid)$"
					}

onClickHandler = (info, tab) ->
	filter = FILTERS[info.menuItemId]
	chrome.tabs.sendMessage(tab.id, "getSelectedLinks", (response) ->
		if response.links.length <= LINK_WARNING_AMOUNT or confirm("You have #{response.links.length} links to open. Are you sure you want to open them all at once?")
			for link in response.links.reverse() when link.match(new RegExp(filter, "i")) and not link.match(BLACKLIST)
				chrome.tabs.create({url:link,index:tab.index+1})
	)

onInstalledHandler = () -> 
	chrome.contextMenus.create({contexts:["all"], id:"parent", title:"Open selected links"})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"all", title:"All"})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", type:"separator"})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"image", title:"Images only"})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"video", title:"Videos only"})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"audio", title:"Audio only"})

chrome.contextMenus.onClicked.addListener(onClickHandler)
chrome.runtime.onInstalled.addListener(onInstalledHandler)