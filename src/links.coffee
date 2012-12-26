onClickHandler = (info, tab) ->
	callback = (response) ->
		console.log("selection: #{response.selection}")
	
	chrome.tabs.sendMessage(tab.id, "getSelection", callback)

onInstalledHandler = () -> 
	title = "Open all links"
	chrome.contextMenus.create({"title": title, "contexts":["selection"], "id": "selection"})

chrome.contextMenus.onClicked.addListener(onClickHandler)
chrome.runtime.onInstalled.addListener(onInstalledHandler)