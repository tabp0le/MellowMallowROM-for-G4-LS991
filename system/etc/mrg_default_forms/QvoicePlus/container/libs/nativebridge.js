
function addDialogCard(url) {
	var transform = expanded ? "translate3d(0,"+170+"px,0)" : "";
	var path = url.split('?')[0];
	folderPath = path.substring(0, path.lastIndexOf("/") + 1);	
	var realstr = url.substring(path.length+1);
	
	var param = JSON.parse(url.substring(path.length+1));
	$.get(path, function(form) {
		var template = _.template(form);
		var $elem = $(template(param));
		$("ul.container").append($elem.css("-webkit-transform","translate3d(0, "+100+"px, 0)"));
		//alert($('button').data('action'));
		urls.push(url);
		setTimeout(function() {
			$elem.css("-webkit-transform", transform);
		}, 0);
	});
}
function addUserUtteranceCard(url) {
	//File://jdkd/user.html?user=show alarm
	var transform = expanded ? "translate3d(0,"+170+"px,0)" : "";
	var path = url.split('?')[0];
	folderPath = path.substring(0, path.lastIndexOf("/") + 1);	
	var realstr = url.substring(path.length+1);

	realstr = realstr.replace(new RegExp( "\\n", "g" ),"<BR>");

	var param = JSON.parse(realstr);

	$.get(path, function(form) {
		var template = _.template(form);
		var $elem = $(template(param));
		$("ul.container").append($elem.css("-webkit-transform","translate3d(0, "+100+"px, 0)"));
		//alert($('button').data('action'));
		urls.push(url);
		setTimeout(function() {
			$elem.css("-webkit-transform", transform);
		}, 0);
	});
}

function addSystemUtteranceCard(url) {
	
	var transform = expanded ? "translate3d(0,"+170+"px,0)" : "";

	var path = url.split('?')[0];
	folderPath = path.substring(0,path.lastIndexOf("/") + 1);	
	var realstr = url.substring(path.length+1);
	
	var realstr = url.substring(path.length+1);

	realstr = realstr.replace(new RegExp( "\\n", "g" ),"<BR>");


	var param = JSON.parse(realstr);

	$.get(path, function(form) {
		var template = _.template(form);
		var $elem = $(template(param));
		$("ul.container").append($elem.css("-webkit-transform","translate3d(0, "+100+"px, 0)"));
		//alert($('button').data('action'));
		urls.push(url);
		setTimeout(function() {
			$elem.css("-webkit-transform", transform);
		}, 0);
	});
}

function addWelcommeUtteranceCard(url) {
	
	var transform = "translate3d(0px,"+500+"px,0)";
	
	var path = url.split('?')[0];
	var lastIndexOfSlash = path.lastIndexOf("/");
	folderPath = path.substring(0,path.lastIndexOf("/") + 1);	
	var realstr = url.substring(path.length+1);

	var param = JSON.parse(realstr);

	$.get(path, function(form) {
		var template = _.template(form);
		var $elem = $(template(param));
$("ul.container").append($elem);
	//	$("ul.container").append($elem.css("-webkit-transform","translate3d(2, "+500+"px, 0)"));
		//alert($('button').data('action'));
		urls.push(url);

	});
}



function clear() {
	$('li').remove();
	$('ul script').remove();
	urls=[];
}