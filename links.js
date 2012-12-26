function onClickHandler(info, tab) {
  chrome.tabs.sendMessage(tab.id, "getSelection", function (response) {
	console.log("selection: " + response.selection);
  });
};

chrome.contextMenus.onClicked.addListener(onClickHandler);

chrome.runtime.onInstalled.addListener(function() {
  var title = "Open all links";
  var id = chrome.contextMenus.create({"title": title, "contexts":["selection"],
                                       "id": "selection"});
});