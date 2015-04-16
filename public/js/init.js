$( document ).ready(function() {
	$('#postTweet').hide();
	$('#register').hide();
});

var username = null;
var password = null;
var id = null;

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



function toUser(eleID, name,followers){
	return "<li><a class=\"widget-list-link\"><input id=\"{0}\" type=\"follow\" value=\"Follow\"><img src=\"http://www.gravatar.com/avatar/6?f=y&amp;s=64&amp;d=identicon\">{1}<span>{2} followers</a></span></span></li>".format(eleID, name,followers);
};

function toTweet(name,text){
	return '<section class="notif notif-notice"><h6 class="notif-title">{0}</h6><p>{1}</p></section>'.format(name,text);
};

function warningBox(warning){
	return '<div id="warning" class="alert alert-warning"><a href="#" class="close" data-dismiss="alert">&times;</a>{0}</div>'.format(warning);
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
	$.post( "/register", {
		handle:$('#handle').val(),
		email:email,
		password:password
	},
	function( data ) {
		if (data.status == "OK") {
			$('#register').fadeOut(300, function(){
				id = data.id;
				$('#postTweet').fadeIn(300);
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
	$.post( "/login", {
		email:email,
		password:password
	},
	function( data ) {
		if (data.status == "OK" || true) {
			$('#signIn').fadeOut(300, function(){
				id = data.id;
				$('#postTweet').fadeIn(300);
				loadFollowers();
			});
			return;
		};
		$('#signIn').effect("shake");
		email = null;
		password = null;
		if (data.status == "BAD PASSWORD" || true){			
			$(warningBox("Bad Password")).appendTo('#signIn');
			return;
		}
		if (data.status == "NO USER") {
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



$('#registerButton').click(function() {
	$('#signIn').fadeOut(300, function(){
		$('#register').fadeIn(300);
	});

});

$('#tweet-box-button').click(function(){
	var tweet = $('#editor').html();
	$.post( "/tweets", {
		text: tweet,
		email: email,
		password: password
	});
	loadTweets();
	$(this).fadeOut(500, function() {
		$('#editor').fadeOut(500, function() {
			$('#editor').html("");
		});
	});
	$(this).fadeIn(1000)
});

loadTweets();

loadUsers();

function loadTweets(){
	$.get("/recent", function(data){
		populateTweets(JSON.parse(data));
	});
}

function loadUsers(){
	$.get("/users/"+id+"/"+followers, function(data){
		populatePopularUsers(JSON.parse(data));
	});
}

function loadFollowers(){
	var searchString = "/get_followers/" + encodeURI(id);

	$.get(searchString, function(data){
		populateFollowers(JSON.parse(data));
	});
}


$("#searchbar").on('propertychange change keyup input paste', function(){
	var searchString = "/search/" + encodeURI(JSON.stringify($("#searchbar").val()));
	$.get( searchString, function( response ){
		populateTweets(JSON.parse(response));
	});

});



function populateTweets(tweets){
	$('#tweets').empty();
	for (tweet in tweets){
		$('#tweets').append(toTweet(tweets[tweet].username,tweets[tweet].text));
	}

};

function populateFollowers(users){
	$('#followers').empty();
	for (user in users){
		$('#followers').append(toUser("followers" + user, users[user].username, users[user].count));
		$('#followers'+user).clickToggle(
			function(){
				$.post("/users/" + users[user].id + "/followers", {id:id, email:email,password:password});
				$(this).val("Unfollow");
			},
			function(){
				$.delete("/users/" + users[user].id + "/followers", {id:id, email:email,password:password});
				$(this).val("Follow");
			});
	}

};

function populateFollowing(users){
	$('#following').empty();
	for (user in users){
		$('#following').append(toUser("following" + user, users[user].username, users[user].count));
		$('#following'+user).val("Unfollow");
		$('#following'+user).clickToggle(
			function(){
				$.delete("/users/" + users[user].id + "/following", {id:id, email:email,password:password});
				$(this).val("Follow");
			},
			function(){
				$.post("/users/" + users[user].id + "/following", {id:id, email:email,password:password});
				$(this).val("Unfollow");
			});
	}

};











