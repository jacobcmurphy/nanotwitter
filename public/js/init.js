var id= null;
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
	return "<section class=\"notif notif-notice\"><h6 class=\"notif-title\">{0}</h6><p>{1}</p></section>".format(name,text);

};


$('#registerConfirmButton').click(function() {
	if (validPassword($('#regPass1').val(),$('#regPass2').val())){
		$.post( "/register", {
			handle:$('#handle').val(),
			email:$('#regEmail').val(),
			password:$('#regPass1').val()
		},
		function( data ) {
			id = data.id;
			$('#register').fadeOut(300, function(){
				$('#postTweet').fadeIn(300);
			});
		});
	} else {
		$('#registerConfirmButton').val("INVALID PASSWORD");
		$('#register').effect("shake");
	}

});


$('#postTweet').tweetbox({
	limit:140, 
});

$('#postTweet').hide();

$('#register').hide();

$('#signInButton').click(function() {
	$.post( "/login", {
		email:$('#email').val(),
		password:$('#password').val()
	},
	function( data ) {
		if (data.status != "OK") {
			$('#signIn').effect("shake");
			return;
		}
		id = data.id;
		$('#signIn').fadeOut(300, function(){
			$('#postTweet').fadeIn(300);
		
			loadFollowers();
		});
	});

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

$('.tweet-box-button').click(function(){
	var tweet = $('#editor').html();
	$.post( "/tweet", {
		text:tweet,
		id: id
	});
	loadTweets();
	$(this).fadeOut(500);
	$(this).fadeIn(1000);
});

loadTweets();

loadPopular();

function loadTweets(){
	$.get("/all", function(data){
		populateTweets(JSON.parse(data));
	});
}

function loadPopular(){
	$.get("/users", function(data){
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



function populatePopularUsers(users){
	$('#popular').empty();
	for (user in users){
		$('#popular').append(toUser("follow" + user, users[user].username, users[user].count));
		$('#follow'+user).clickToggle(
			function(){
				$.post("/follow",{"user_id":id, "followee_id":users[user].id});
				$(this).val("Unfollow");
		},
			function(){
				$.post("/unfollow",{"user_id":id, "followee_id":users[user].id});
				$(this).val("Follow");
			});
				
			
	};

};

function populateFollowers(users){
	$('#following').empty();
	for (user in users){
		$('#following').append(toUser("follow" + user, users[user].username, users[user].count));
		$('#following'+user).clickToggle(
			function(){
				$.post("/follow",{"user_id":id, "followee_id":users[user].id});
				$(this).val("Unfollow");
		},
			function(){
				$.post("/unfollow",{"user_id":id, "followee_id":users[user].id});
				$(this).val("Follow");
			});
				
			
	};

};







$('#tweet-box-button').click(function() {
	$.post( "/", {"text":tweet,"user_id":1});

});


function populateTweets(tweets){
	$('#tweets').empty();
	for (tweet in tweets){
		$('#tweets').append(toTweet(tweets[tweet].username,tweets[tweet].text));
	}

};







