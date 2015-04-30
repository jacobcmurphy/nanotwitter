var id = readCookie("id");
var email = readCookie("email");
var password = readCookie("password");
var cachedFollowing = null;


$( document ).ready(function() {
	if (id==null){
		$('#signIn').show();
	} else {
		$('#postTweet').show();
		loadFollowers();
		loadFollowing();
	}
});






function createCookie(name, value, days) {
	var expires;

	if (days) {
		var date = new Date();
		date.setTime(date.getTime() + (days * 24 * 60 * 60 * 1000));
		expires = "; expires=" + date.toGMTString();
	} else {
		expires = "";
	}
	document.cookie = encodeURIComponent(name) + "=" + encodeURIComponent(value) + expires + "; path=/";
}

function readCookie(name) {
	var nameEQ = encodeURIComponent(name) + "=";
	var ca = document.cookie.split(';');
	for (var i = 0; i < ca.length; i++) {
		var c = ca[i];
		while (c.charAt(0) === ' ') c = c.substring(1, c.length);
		if (c.indexOf(nameEQ) === 0) return decodeURIComponent(c.substring(nameEQ.length, c.length));
	}
	return null;
}

function eraseCookie(name) {
	createCookie(name, "", -1);
}

String.prototype.format = function() {
	var formatted = this;
	for (var i = 0; i < arguments.length; i++) {
		var regexp = new RegExp('\\{'+i+'\\}', 'gi');
		formatted = formatted.replace(regexp, arguments[i]);
	}
	return formatted;
};

(function($) {
	$.fn.clickToggle = function(func1, func2) {
		var funcs = [func1, func2];
		this.data('toggleclicked', 0);
		this.click(function() {
			var data = $(this).data();
			var tc = data.toggleclicked;
			$.proxy(funcs[tc], this)();
			data.toggleclicked = (tc + 1) % 2;
		});
		return this;
	};
}(jQuery));

jQuery.each( [ "put", "delete" ], function( i, method ) {
	jQuery[ method ] = function( url, data, callback, type ) {
		if ( jQuery.isFunction( data ) ) {
			type = type || callback;
			callback = data;
			data = undefined;
		}

		return jQuery.ajax({
			url: url,
		       type: method,
		       dataType: type,
		       data: data,
		       success: callback
		});
	};
});


function toUser(eleID, name,count){
	return '<li><a class="widget-list-link" id={0}dialog><img src="http://edenzik.github.io/nanotwitter/public/img/icon.png"><h7 id="{1}dialog">{1}</h7><span>{2} followers</a></span></span></li>'.format(eleID, name,count);
};

function toTweet(name,text,date){
	return '<section class="temp notif notif-notice"><a><h6 class="{0}tweet notif-title">{0}</h6></a><p>{1}<div class="tweet_date">{2}</div></section>'.format(name,text,date);
};

function warningBox(warning){
	return '<div id="warning" class="alert alert-warning"><a href="#" class="close" data-dismiss="alert">&times;</a>{0}</div>'.format(warning);
}

function toUserBox(eleID, name, content){
	if (content==""){
		content = "<h1>No tweets to show</h1>";
	}
	return '<div id="{0}" class="modal fade"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button><h4 class="modal-title">{1}\'s Tweets</h4><input id="{0}follow" type="follow" class="follow-button" value="Follow"></div>{2}</div>'.format(eleID, name, content);
}



$('#registerConfirmButton').click(function() {
	$('#warning').remove();
	var isValidPass = validPassword($('#regPass1').val(),$('#regPass2').val());
	if (!isValidPass){
		$(warningBox("Bad Password")).appendTo('#register');
		$('#register').effect("shake");
		return;
	}
	email = $('#regEmail').val();
	password = $('#regPass1').val();
	$.post( "/account/register", {
		username:$('#username').val(),
		email:email,
		password:password
	},
	function( data ) {
		data = JSON.parse(data);
		if (data.status == "USER CREATED") {
			$('#register').fadeOut(300, function(){
				id = data.id;
				$('#postTweet').fadeIn(300);
				loadFollowers();
				loadFollowing();
				$('#email').val("");
				$('#password').val("");
				$('#signOut').fadeIn(300);
				createCookie("email",email,1);
				createCookie("password",password,1);
				createCookie("id",id,1);
				loadTweetsOfFollowers();
			});
			return;
		}
		if (data.status == "USER EXISTS"){
			$(warningBox("USER EXISTS")).appendTo('#register');
		} else {
			$(warningBox("Something went wrong...")).appendTo('#register');
		}
		$('#register').effect("shake");
		return;
	});

});



$('#signInButton').click(function() {
	$('#warning').remove();
	email = $('#email').val();
	password = $('#password').val();
	if (email=="" || password==""){
		$('#signIn').effect("shake");
		return;
	}
	$.post( "/account/login", {
		email:email,
		password:password
	},
	function( data ) {
		data = JSON.parse(data);
		if (data.status == "OK") {
			$('#signIn').fadeOut(300, function(){
				id = data.id;
				$('#postTweet').fadeIn(300);
				loadFollowers();
				loadFollowing();
				$('#email').val("");
				$('#password').val("");
				$('#signOut').fadeIn(300);
				createCookie("email",email,1);
				createCookie("password",password,1);
				createCookie("id",id,1);
				loadTweetsOfFollowers();
			});
			return;
		};
		$('#signIn').effect("shake");
		email = null;
		password = null;
		if (data.status == "BAD PASSWORD"){			
			$(warningBox("Bad Password")).appendTo('#signIn');
			return;
		}
		if (data.status == "NOT FOUND") {
			$(warningBox("User does not exist")).appendTo('#signIn');
			return;
		}
	});
});



$('#postTweet').tweetbox({
	limit:140, 
});



function validPassword(pass1, pass2){
	if (pass1.length < 8) return false;
	return pass1==pass2;
}

$('#signOutButton').click(function() {
	id = null;
	email = null;
	password = null;
	$('#signOut').fadeOut(100);
	$('#postTweet').fadeOut(100, function() {
		
			$('#signIn').fadeIn(100, function(){
				$('#followers').empty();
				$('#following').empty();
				eraseCookie("id");
				eraseCookie("email");
				eraseCookie("password");
				loadTweets();

			});
	});
	$(".follow-button").hide();

});



$('#registerButton').click(function() {
	$('#signIn').fadeOut(300, function(){
		$('#register').fadeIn(300);
	});

});

$('#tweet-box-button').click(function(){
	var tweet = $('#editor').html();
	$.post( "/api/v1/tweet", {
		text: tweet,
		email: email,
		password: password
	});
	loadTweets();
	$(this).fadeOut(500, function() {
		$('#editor').html("");
	});
	$(this).fadeIn(1000)
});

loadTweets();


function loadTweets(){
	$('#tweets').empty();
	$.get("/api/v1/tweet", function(data){
		populateTweets(JSON.parse(data));
	});
}

function loadTweetsOfFollowers(){
	$('.temp').remove();
	$('#tweets').empty();
	$.get("/api/v1/tweet/to/"+id, function(data){
		populateTweets(JSON.parse(data));
	});
}

loadAll();

function loadAll(){
	$.get("api/v1/user/", function(data){
		populateAll(JSON.parse(data));
	});
}

function loadFollowers(){
	$('#followers').empty();
	$.get("api/v1/follow/to/"+id, function(data){
		populateFollowers(JSON.parse(data));
	});
}

function loadFollowing(){
	$('#following').empty();
	cachedFollowing = [];
	$.get("api/v1/follow/from/"+id, function(data){
		var data = JSON.parse(data);
		data.map(function(user){
			cachedFollowing.push(user.followee_id);	
		});
		populateFollowing(data);
	});
}

function loadTweetsOfUser(user_id, username, follower){
	$('#'+user_id+'dialog').remove();
	var tweetsOfUser = "";
	$.get("api/v1/tweet/"+user_id, function(data){
		var tweets = JSON.parse(data);
		for (tweet in tweets){
			tweetsOfUser += toTweet(tweets[tweet].username,tweets[tweet].text,tweets[tweet].created);
		}

		$(document.body).append(toUserBox(user_id+'dialog', username, tweetsOfUser));
		$("#" + user_id + 'dialog').modal('show');
		if (id==null){
			$('#' + user_id + 'dialogfollow').hide();
		}
		else {
			$('#' + user_id + 'dialogfollow').show();
		}
	var to_follow = function(){
		$.post("/api/v1/follow/to/" + user_id, {id:id, email:email,password:password});
		loadFollowing();
		loadFollowers();
		$('#' + user_id + 'dialogfollow').val("Unfollow");
	};
	var to_unfollow = function(){
		$.delete("/api/v1/follow/to/" + user_id, {id:id, email:email,password:password});
		loadFollowing();
		loadFollowers();
		$('#' + user_id + 'dialogfollow').val("Follow");
	}
	if ($.inArray(user_id, cachedFollowing) == 0){
		$('#' + user_id + 'dialogfollow').val("Unfollow");
		$('#' + user_id + 'dialogfollow').clickToggle(to_unfollow,to_follow);
	}
	else {
		$('#' + user_id + 'dialogfollow').val("Follow");
		$('#' + user_id + 'dialogfollow').clickToggle(to_follow,to_unfollow);
	}
	});

}








$("#searchbar").on('propertychange change keyup input paste', function(){
	var searchString = $("#searchbar").val();
	if (searchString == ""){
		if (id==null) {
			loadTweets();
			return;
		}
		loadTweetsOfFollowers();
		return;
	}
	searchString = "/api/v1/tweet/search/" + searchString;
	$.get( searchString, function( response ){
		populateTweets(JSON.parse(response));
	});

});

function populateTweets(tweets){
	$('#tweets').empty();
	for (tweet in tweets){
		$('#tweets').append(toTweet(tweets[tweet].username,tweets[tweet].text,tweets[tweet].created));
		( function (user) {
			$('.'+user.username + 'tweet').unbind();
			$('.'+user.username + 'tweet').click(function(){
				loadTweetsOfUser(user.id, user.username, "");
			});
		})(tweets[tweet]);
	}
};

function populateFollowers(users){
	for (user in users){
		$('#followers').append(toUser("followers" + user, users[user].follower, users[user].count));
		( function (user) {
			$('#followers'+ user + 'dialog').click(function(){
				loadTweetsOfUser(users[user].follower_id, users[user].follower);
			});
		})(user);
	}

};

function populateFollowing(users){
	$('#following').empty();
	for (user in users){
		$('#following').append(toUser("following" + user, users[user].followee, users[user].count));
		( function (user) {
			$('#following'+ user + 'dialog').click(function(){
				loadTweetsOfUser(users[user].followee_id, users[user].followee);
			});
		})(user);

	}

};


function populateAll(users){
	$('#all').empty();
	for (user in users){
		//	console.log(users[user].count);
		$('#all').append(toUser("all" + user, users[user].username, users[user].count));
		( function (user) {
			$('#all'+ user + 'dialog').click(function(){
				loadTweetsOfUser(users[user].id, users[user].username);
			});
		})(user);
	}

};












