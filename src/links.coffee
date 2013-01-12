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

@links = []
@linksForFilter = {}

onInstalledHandler = ->
	chrome.contextMenus.create({contexts:["all"], id:"parent", title:chrome.i18n.getMessage("menu_main")})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"all", title:chrome.i18n.getMessage("menu_sub_all")})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", type:"separator"})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"image", title:chrome.i18n.getMessage("menu_sub_image")})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"video", title:chrome.i18n.getMessage("menu_sub_video")})
	chrome.contextMenus.create({contexts:["all"], parentId:"parent", id:"audio", title:chrome.i18n.getMessage("menu_sub_audio")})

onMessageHandler = (request, sender, sendResponse) ->
	if request.type == "verifySelection"
		@links = request.links
		for own key, value of FILTERS
			@linksForFilter[key] = filterLinks(value)
			updateContextMenu(key)
	# todo: store current selection for optimization (in case it asks for the same extension again next time)
	# todo: show up to three links directly (+ all)

filterLinks = (filter) ->
	link for link in @links.reverse() when link.match(new RegExp(filter, "i")) and not link.match(BLACKLIST)

updateContextMenu = (id) -> 
	links = @linksForFilter[id]
	title = chrome.i18n.getMessage("menu_sub_#{id}", [links.length])
	chrome.contextMenus.update(id, {title:title, enabled:links.length > 0})

onClickHandler = (info, tab) ->
	links = @linksForFilter[info.menuItemId]
	if links.length <= LINK_WARNING_AMOUNT or confirm(chrome.i18n.getMessage("selection_alert_tooManyLinks", [links.length]))
		for link in links
			chrome.tabs.create({url:link,index:tab.index+1})

chrome.runtime.onInstalled.addListener(onInstalledHandler)
chrome.extension.onMessage.addListener(onMessageHandler)
chrome.contextMenus.onClicked.addListener(onClickHandler)