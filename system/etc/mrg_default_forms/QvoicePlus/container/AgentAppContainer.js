var urls = [];
var expanded = false;
_.templateSettings.variable = "data";
//alert("innerWidth :" + window.innerWidth +" / pixelRatio : " + window.devicePixelRatio);

function deleteButton(event) {
	$(event.target.parentElement.parentElement).css("-webkit-transform", "translateX(320px)").one("webkitTransitionEnd", function() {
		$(this).remove();
		urls.pop();
	});
}
