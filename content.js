chrome.extension.onMessage.addListener(function(request, sender, sendResponse)
{
  if (request == "getSelection")
  {
	var selection = window.getSelection();
	var container = document.createElement("div");
	for (var i = 0, len = selection.rangeCount; i < len; ++i) {
		container.appendChild(selection.getRangeAt(i).cloneContents());
	}
	var html = container.innerHTML;
    sendResponse({selection: html});
  }
  else
  {
	sendResponse({}); // snub them.
  }  
});