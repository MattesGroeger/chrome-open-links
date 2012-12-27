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