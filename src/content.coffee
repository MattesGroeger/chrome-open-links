onMessageHandler = (request, sender, sendResponse) ->
	if request == "getSelection"
		selection = window.getSelection()
		container = document.createElement("div")
		count = selection.rangeCount
		for i in [0...count]
			container.appendChild(selection.getRangeAt(i).cloneContents())
		html = container.innerHTML
		sendResponse({selection:html})
	else
		sendResponse({})

chrome.extension.onMessage.addListener(onMessageHandler)