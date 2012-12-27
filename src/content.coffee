onMessageHandler = (request, sender, sendResponse) ->
	if request == "getSelectedLinks"
		sendResponse {links:getLinksFromSelection()}
	else
		sendResponse {}

getLinksFromSelection = ->
	selection = window.getSelection()
	container = document.createElement "div"
	appendChild(container, selection, i) for i in [0...selection.rangeCount]
	aTags = container.getElementsByTagName "a"
	allLinks = for tag in aTags
		tag.href

appendChild = (container, selection, rangeIndex) ->
	container.appendChild selection.getRangeAt(rangeIndex).cloneContents()

chrome.extension.onMessage.addListener(onMessageHandler)